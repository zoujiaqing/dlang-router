module hunt.router.route;

import hunt.router.define;

class Route
{
    this()
    {
        // Constructor code
    }

    public
    {
        void setGroup(string groupValue)
        {
            this._group = groupValue;
        }

        string getGroup()
        {
            return this._group;
        }

        void setTemplate(string templateValue)
        {
            this._template = templateValue;
        }

        string getTemplate()
        {
            return this._template;
        }

        void setRoute(string routeValue)
        {
            this._route = routeValue;
        }

        string getRoute()
        {
            return this._route;
        }

        void setPattern(string patternValue)
        {
            this._pattern = patternValue;
        }

        string getPattern()
        {
            return this._pattern;
        }

        void setRegular(bool regularValue)
        {
            this._regular = regularValue;
        }

        void setModule(string moduleValue)
        {
            this._module = moduleValue;
        }

        string getModule()
        {
            return this._module;
        }

        void setController(string controllerValue)
        {
            this._controller = controllerValue;
        }

        string getController()
        {
            return this._controller;
        }

        void setAction(string actionValue)
        {
            this._action = actionValue;
        }

        string getAction()
        {
            return this._action;
        }

        void setMethods(HTTP_METHOS[] methods)
        {
            this._methods = methods;
        }

        HTTP_METHOS[] getMethods()
        {
            return this._methods;
        }
    }

    private
    {
        // Route group name
        string _group;

        // Regex template
        string _template;

        // http uri params
        string[string] _params;

        // like uri path
        string _pattern;

        // path to module.controller.action
        string _route;

        // use regex?
        bool _regular;

        // hunt module
        string _module;

        // hunt controller
        string _controller;

        // hunt action
        string _action;

        // allowd http methods
        HTTP_METHOS[] _methods = [ HTTP_METHOS.GET, HTTP_METHOS.POST, HTTP_METHOS.PUT, HTTP_METHOS.DELETE ];
    }
}
