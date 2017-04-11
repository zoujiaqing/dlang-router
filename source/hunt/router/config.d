﻿module hunt.router.config;

import hunt.router.define;

struct RouteItem
{
    string methods;
    string path;
    string route;
}

struct Config
{
    RouteItem[] loadConfig(string filename)
    {
        import std.stdio;

        RouteItem[] items;

        auto f = File(filename);

        scope(exit)
        {
            f.close();
        }

        foreach (line; f.byLine)
        {
            RouteItem item = this.parseOne(line);
            if (item.path.length > 0)
            {
                items ~= item;
            }
        }

        return items;
    }

    RouteItem parseOne(char[] line)
    {
        import std.string : strip;
        import std.regex;
        import std.conv;

        RouteItem item;

        line = strip(line);

        // not availabale line return null
        if (line.length == 0 || line[0] == '#')
        {
            return item;
        }

        // match example: GET, POST    /users    module.controller.action
        auto matched = line.match(regex(`([\w,\s]+[\w])\s+(/.+)\s([\w\.]+)`));

        if (matched)
        {
            item.methods = matched.captures[1].to!string.strip;
            item.path = matched.captures[2].to!string.strip;
            item.route = matched.captures[3].to!string.strip;
        }

        return item;
    }
}
