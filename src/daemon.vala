/*
 * Copyright (C) 2010 Canonical Ltd
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 3 as
 * published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * Authored by Rémi Rérolle <remi.rerolle@gmail.com>
 *
 */
using Unity;
using GLib;

[DBus(name="org.gnome.Tomboy.RemoteControl")]
interface RemoteControl : GLib.Object
{
    public abstract bool DisplayNote(string uri) throws IOError;
    public abstract string[] SearchNotes(string query, bool case_sensitive) throws IOError;
    public abstract string[] ListAllNotes() throws IOError;
    public abstract string GetNoteTitle(string uri) throws IOError;
}

namespace Unity.TomboyLens
{
    public class Daemon : GLib.Object
    {
        private Unity.Lens lens;
        private Unity.Scope scope;
        private RemoteControl tomboy;

        construct
        {
            try
            {
                scope = new Unity.Scope("/com/canonical/Unity/Scope/Tomboy");
                scope.notify["active-search"].connect(on_search_changed);
                scope.notify["active-global-search"].connect(on_global_search_changed);
                scope.activate_uri.connect(activate);
                scope.export();
                lens = new Unity.Lens("/com/canonical/Unity/Lens/Tomboy",
                                      "tomboy");
                lens.search_hint = _("Search Tomboy notes");
                lens.visible = true;
                lens.search_in_global = true;
                populate_categories();
                populate_filters();
                lens.add_local_scope(scope);
                lens.export();
                tomboy = Bus.get_proxy_sync(
                    BusType.SESSION,
                    "org.gnome.Tomboy",
                    "/org/gnome/Tomboy/RemoteControl"
                );
            }
            catch (IOError e)
            {
                error("Error while initializing Tomboy lens: %s", e.message);
            }
        }

        private void populate_categories()
        {
            List<Unity.Category> categories = new List<Unity.Category>();
            categories.append(new Unity.Category(_("Tomboy notes"),
                                                 new ThemedIcon("tomboy")));
            lens.categories = categories;
        }

        private void populate_filters()
        {
            List<Unity.Filter> filters = new List<Unity.Filter>();
            lens.filters = filters;
        }

        private void on_search_changed(GLib.Object obj, ParamSpec pspec)
        {
            Unity.LensSearch? search = scope.active_search;
            if (search == null)
                update_result_model(scope.results_model,
                                    "");
            else
                update_result_model(scope.results_model,
                                    search.search_string);
            search.finished();
        }

        private void on_global_search_changed(GLib.Object obj, ParamSpec pspec)
        {
            Unity.LensSearch? search = scope.active_global_search;
            if (search == null)
                return;
            update_result_model(scope.global_results_model,
                                search.search_string);
            search.finished();
        } 

        private void update_result_model(Dee.Model results_model, string search)
        {
            try
            {
                string[] uri_list = null;

                if (search != "")
                    uri_list = tomboy.SearchNotes(search, false);
                else
                    uri_list = tomboy.ListAllNotes();

                results_model.clear();
                foreach (string uri in uri_list)
                    results_model.append(uri, "tomboy", 0, "application/x-note",
                                         tomboy.GetNoteTitle(uri), "", uri);
            }
            catch (IOError e)
            {
                debug("Error while searching for %s: %s", search, e.message);
            }
        }

        public Unity.ActivationResponse activate(string uri)
        {
            try
            {
                tomboy.DisplayNote(uri);
            }
            catch (IOError e)
            {
                warning("Error while activating note %s: %s", uri, e.message);
            }
            return new Unity.ActivationResponse(Unity.HandledType.HIDE_DASH);
        }
    }
}

