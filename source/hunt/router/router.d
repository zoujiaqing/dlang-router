module hunt.router.router;

import hunt.router.define;
import hunt.router.routegroup;
import hunt.router.route;
import hunt.router.config;

class Router
{
    public
    {
        void setConfigPath(string path)
        {
            // supplemental slash
            this._configPath = (path[path.length-1] == '/') ? path : path ~ "/";
        }

        void addGroup(string group)
        {
            RouteGroup routeGroup = _groups.get(group, null);

            if (routeGroup is null)
            {
                routeGroup = new RouteGroup(group);
                
                this._groups[group] = routeGroup;
            }
            else
            {
                // have this group?
            }
        }

        void loadConfig()
        {
            // load this group routes from config file
            foreach (key, obj; this._groups)
            {
                this.loadConfig(key);
            }
        }

        void reloadGroup(string group)
        {
            this._groups.remove(group);

            this.addGroup(group);
            this.loadConfig(group);
        }

        Router addRoute(string group, Route route)
        {
            //
            RouteGroup routeGroup = this._groups.get(group,null);
            if (!routeGroup)
            {
                routeGroup = new RouteGroup(group);

                this._groups[group] = routeGroup;
            }

            return this;
        }

        Router addRoute(Route route)
        {
            this.addRoute(DEFUALT_ROUTE_GROUP, route);

            return this;
        }

        Route match(string path, string group = DEFUALT_ROUTE_GROUP)
        {
            return this._groups.get(group, null).match(path);
        }
    }

    private
    {
        //
        void loadConfig(string group = DEFUALT_ROUTE_GROUP)
        {
            auto routeGroup = this._groups.get(group, null);
            if (routeGroup is null)
            {
                warningf("Group [%s] non-existent.", group);
                return;
            }

            string configFile = (DEFUALT_ROUTE_GROUP == group) ? this._configPath ~ "routes" : this._configPath ~ group ~ ".routes";
            
            // read file content
            Config config;
            RouteItem[] items = config.loadConfig(configFile);

            Route route;

            foreach (item; items)
            {
                route = this.makeRoute(item.methods, item.path, item.route, group);
                if (route)
                {
                    routeGroup.addRoute(route);
                }
            }
        }

        Route makeRoute(string methods, string path, string mca, string group = DEFUALT_ROUTE_GROUP)
        {
            auto route = new Route();

            route.setGroup(group);
            route.setPattern(path);
            route.setRoute(mca);

            import std.string : split;
            string[] mcaArray = split(mca, ".");

            if (mcaArray.length > 3 || mcaArray.length < 2)
            {
                warningf("this route config mca length is: %d (%s)", mcaArray.length, mca);
                return null;
            }

            if (mcaArray.length == 2)
            {
                route.setController(mcaArray[0]);
                route.setAction(mcaArray[1]);
            }
            else
            {
                route.setModule(mcaArray[0]);
                route.setController(mcaArray[1]);
                route.setAction(mcaArray[2]);
            }

            import std.regex;
            import std.array;

            auto matches = path.matchAll(regex(`<(\w+):([^>]+)>`));
            if (matches)
            {
                string[int] paramKeys;
                int paramCount = 0;
                string pattern = path;
                string urlTemplate = path;

                foreach (m; matches)
                {
                    paramKeys[paramCount] = m[1];
                    pattern = pattern.replaceFirst(m[0], "(" ~ m[2] ~ ")");
                    urlTemplate = urlTemplate.replaceFirst(m[0], "{" ~ m[1] ~ "}");
                    paramCount++;
                }

                route.setPattern(pattern);
                route.setParamKeys(paramKeys);
                route.setRegular(true);
                route.setUrlTemplate(urlTemplate);
            }

            return route;
        }
    }

    private
    {
        RouteGroup[string] _groups;

        string _configPath = "config/";
    }
}
