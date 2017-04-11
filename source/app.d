import std.stdio;

import hunt.router;

void main()
{
    Router router = new Router;

    router.addGroup("default");
    router.addGroup("admin");
    router.addGroup("api");

    router.setConfigPath("config/");
    router.loadConfig();

    Route route = router.match("/users");
    if (route)
    {
        writeln("MCA is:" ~ route.getModule() ~ route.getController() ~ route.getAction());
    }
    else
    {
        writeln("404 Not Found");
    }
    
    Route route2 = router.match("/user/12345", "api");
    if (route2)
    {
        writeln("MCA is:" ~ route2.getModule() ~ route2.getController() ~ route2.getAction());
    }
    else
    {
        writeln("404 Not Found");
    }
    
    Route route3 = router.match("/user/admin/tag/test1", "api");
    if (route3)
    {
        writeln("MCA is:" ~ route3.getModule() ~ route3.getController() ~ route3.getAction());
    }
    else
    {
        writeln("404 Not Found");
    }
}
