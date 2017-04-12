module hunt.router.router;

import hunt.router.define;
import hunt.router.routegroup;
import hunt.router.route;
import hunt.router.config;

class Router
{
    public
    {
        this()
        {
            this._defaultGroup = new RouteGroup(DEFUALT_ROUTE_GROUP);
        }

        void setConfigPath(string path)
        {
            // supplemental slash
            this._configPath = (path[path.length-1] == '/') ? path : path ~ "/";
        }

        void addGroup(string group, string method, string value)
        {
            RouteGroup routeGroup = ("domain" == method) ? _domainGroups.get(group, null) : _directoryGroups.get(group, null);

            if (routeGroup is null)
            {
                routeGroup = new RouteGroup(group);

                _groups[group] = routeGroup;

                if ("domain" == method)
                {
                    _domainGroups[value] = routeGroup;
                }
                else
                {
                    _directoryGroups[value] = routeGroup;
                }

                this._supportMultipleGroup = true;
            }
        }

        void loadConfig()
        {
            this.loadConfig(DEFUALT_ROUTE_GROUP);

            // load this group routes from config file
            foreach (key, obj; this._groups)
            {
                this.loadConfig(key);
            }
        }

        void setSupportMultipleGroup(bool enabled = true)
        {
            this._supportMultipleGroup = enabled;
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

        Route match(string domain, string method, string path)
        {
            if (false == this._supportMultipleGroup)
            {
                // don't support multiple route group, use defualt group match function
                return this._defaultGroup.match(path);
            }

            RouteGroup routeGroup;

            routeGroup = this.getGroupByDomain(domain);

            if (!routeGroup)
            {
                import std.array;
                string directory = split(path, "/")[1];
                routeGroup = this.getGroupByDirectory(directory);
                if (routeGroup)
                {
                    path = path[directory.length .. $];
                }
                else
                {
                    routeGroup = this._defaultGroup;
                }
            }

            return routeGroup.match(path);
        }
    }

    private
    {
        //
        void loadConfig(string group = DEFUALT_ROUTE_GROUP)
        {
            RouteGroup routeGroup;

            if (group == DEFUALT_ROUTE_GROUP)
            {
                routeGroup = this._defaultGroup;
            }
            else
            {
                routeGroup = this._groups.get(group, null);
                if (routeGroup is null)
                {
                    warningf("Group [%s] non-existent.", group);
                    return;
                }
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

        RouteGroup getGroupByDomain(string domain)
        {
            return this._domainGroups.get(domain, null);
        }

        RouteGroup getGroupByDirectory(string directory)
        {
            return this._groups.get(directory, null);
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
            
            string className;

            if (mcaArray.length == 2)
            {
                route.setController(mcaArray[0]);
                route.setAction(mcaArray[1]);

                className = "app.controller." ~ ((group == DEFUALT_ROUTE_GROUP) ? "" : group ~ ".") ~ route.getController() ~ "controller";
            }
            else
            {
                route.setModule(mcaArray[0]);
                route.setController(mcaArray[1]);
                route.setAction(mcaArray[2]);

                className = "app." ~ route.getModule() ~ ".controller." ~ ((group == DEFUALT_ROUTE_GROUP) ? "" : group ~ ".") ~ route.getController() ~ "controller";
            }

            import std.string : toLower;

            className = className.toLower;

            trace(className);

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
        RouteGroup _defaultGroup;

        RouteGroup[string] _directoryGroups;
        RouteGroup[string] _domainGroups;
        RouteGroup[string] _groups;

        // enable muiltple route group
        bool _supportMultipleGroup = false;

        string _configPath = "config/";
    }
}
