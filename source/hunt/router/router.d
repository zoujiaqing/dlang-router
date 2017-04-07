module hunt.router.router;

import hunt.router.routegroup;
import hunt.router.route;

class Router
{
	this()
	{
		// Constructor code
	}

	public
	{
		void setConfigPath(string path)
		{
			this._configPath = path;
		}

		void addGroup(string group)
		{
			RouteGroup routeGroup = this._groups.get(group);
			if (!routeGroup)
			{
				routeGroup = new RouteGroup(group);
				
				this._groups[group] = routeGroup;
			}
			else
			{
				// have this group?
			}

			// load this group routes from config file
			this.loadConfig(group);
		}

		Router addRoute(string group, Route route)
		{
			//
			RouteGroup routeGroup = this._groups.get(group);
			if (!routeGroup)
			{
				routeGroup = new RouteGroup(group);

				this._groups[group] = routeGroup;
			}

			return this;
		}

		Router addRoute(Route route)
		{
			this.addRoute("default", route);

			return this;
		}

		Route match(string path, string group = "default")
		{
			//
		}
	}

	private
	{
		//
		void loadConfig(string group = "default")
		{
			string configFile = ("defualt" == group) ? this._configPath ~ "routes" : this._configPath ~ group ~ "routes";
			
			// read file content
		}
	}

	private
	{
		RouteGroup[string] _groups;

		string _configPath = "config/";
	}
}
