module hunt.router.routegroup;

import hunt.router.define;
import hunt.router.route;

class RouteGroup
{
    this(string name = DEFUALT_ROUTE_GROUP)
    {
        this._name = name;
    }

    public
    {
        void setName(string name)
        {
            this._name = name;
        }

        string getName()
        {
            return this._name;
        }

        RouteGroup addRoute(Route route)
        {
            if (route.getRegular())
            {
                this._regexRoutes ~= route;
            }
            else
            {
                this._routes[route.getPattern()] = route;
            }

            return this;
        }

        Route match(string path)
        {
            Route route;

            route = this._routes.get(path, null);

            if (route)
            {
                return route;
            }

            import std.regex;

            foreach (r; this._regexRoutes)
            {
                auto matched = path.match(regex(r.getPattern()));
                if (matched)
                {
                    route = r;

                    string[string] params;

                    foreach(i, key; route.getParamKeys())
                    {
                        params[key] = matched.captures[i + 1];
                    }

                    route.setParams(params);

                    return route;
                }
            }

            return null;
        }
    }

    private
    {
        string _name;
        Route[string] _routes;
        Route[] _regexRoutes;
    }
}
