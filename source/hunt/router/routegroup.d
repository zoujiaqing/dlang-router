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
            this._routes[route.getPattern()] = route;

            return this;
        }
    }

    private
    {
        string _name;
        Route[string] _routes;
    }
}
