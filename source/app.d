import std.stdio;

import hunt.router;

void main()
{
    Router router = new Router;

    router.addGroup("default");
    router.addGroup("admin");
    router.addGroup("api");

    router.setConfigPath("config/");

    Route route = router.match("/users");
    if (route)
    {
        writeln("MCA is:" ~ route.getModule() ~ route.getController() ~ route.getAction());
    }
    else
    {
        writeln("404 Not Found");
    }

    Route route = router.match("/user/add", "admin");
    if (route)
    {
        writeln("MCA is:" ~ route.getModule() ~ route.getController() ~ route.getAction());
    }
    else
    {
        writeln("404 Not Found");
    }
}
