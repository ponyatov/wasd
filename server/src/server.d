/// @file
/// @brief tiny HTTP server for SPA applications

module server;

/// @defgroup server server
/// @brief tiny HTTP server for SPA applications
/// @{

import config;

import std.stdio;
import std.range;
import std.socket;

/// @brief program entry point
/// @param[in] args command line arguments
void main(string[] args) {
    arg(0, args[0]);
    foreach (argc, argv; args[1 .. $].enumerate(1)) {
        arg(argc, argv);
    }
    serve(config.IP,config.PORT);
}

/// @brief print single command line argument
/// @param[in] argc index
/// @param[in] argv value
void arg(int argc, string argv) {
    writefln("argv[%d] = <%s>", argc, argv);
}

void serve(string ip, uint16_t port) {
    writefln("http://%s:%d",ip,port);
}

/// @}
