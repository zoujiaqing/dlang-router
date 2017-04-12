import std.stdio;

import hunt.router;

void main()
{
    Router router = new Router;

    router.addGroup("admin", "domain", "admin.localhost.com");
    router.addGroup("api", "directory", "apis");

    router.setConfigPath("config/");
    router.loadConfig();

    Route route = router.match("localhost", "GET", "/users");
    if (route)
    {
        writeln("MCA is:" ~ route.getModule() ~ route.getController() ~ route.getAction());
    }
    else
    {
        writeln("404 Not Found");
    }
    
    Route route2 = router.match("localhost", "POST","/user/12345");
    if (route2)
    {
        writeln("MCA is:" ~ route2.getModule() ~ route2.getController() ~ route2.getAction());
    }
    else
    {
        writeln("404 Not Found");
    }
    
    Route route3 = router.match("localhost", "DELETE", "/apis/user/admin/tag/test1");
    if (route3)
    {
        writeln("MCA is:" ~ route3.getModule() ~ route3.getController() ~ route3.getAction());
    }
    else
    {
        writeln("404 Not Found");
    }
}
