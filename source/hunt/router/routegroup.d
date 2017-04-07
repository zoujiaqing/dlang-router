module hunt.router.routegroup;

import hunt.router.route;

class RouteGroup
{
    this(string name)
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
            this._routes[route.getPartern()] = route;

            return this;
        }

    }

    private
    {
        string _name;
        Route[string] _routes;
    }
}
