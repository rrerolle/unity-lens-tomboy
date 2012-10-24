/*
 * Copyright (C) 2011 Rémi Rérolle
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
                scope.search_in_global = true;
                scope.search_changed.connect(on_search_changed);
                scope.activate_uri.connect(on_uri_activate);
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

        private void on_search_changed (Scope scope, LensSearch search,
                                        SearchType search_type, Cancellable cancellable)
        {
            update_model (search);
            search.finished();
        }

        private void update_model(Unity.LensSearch search)
        {
            try
            {
                string[] uri_list = null;

                if (search.search_string != "")
                    uri_list = tomboy.SearchNotes(search.search_string, false);
                else
                    uri_list = tomboy.ListAllNotes();

                search.results_model.clear();
                foreach (string uri in uri_list)
                    search.results_model.append(uri, "tomboy", 0, "application/x-note",
                                         tomboy.GetNoteTitle(uri), "", uri);
            }
            catch (IOError e)
            {
                debug("Error while searching for %s: %s", search.search_string, e.message);
            }
        }

        public Unity.ActivationResponse on_uri_activate(string uri)
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

