#include <inttypes.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <hiredis/hiredis.h>
#include "db.h"

static redisContext *redis_ctx;

int redis_connect(void)
{
    const char *addr;
    const char *port;
    const char *password;
    struct timeval timeout = { 1, 500000 }; // 1.5 seconds
    redisReply *reply;

    addr = getenv("REDIS_ADDR");
    port = getenv("REDIS_PORT");
    password = getenv("REDIS_AUTH");

    redis_ctx = redisConnectWithTimeout(addr, atoi(port), timeout);
    if (redis_ctx == NULL || redis_ctx->err) {
        if (redis_ctx) {
            fprintf(stderr, "Redis connection error: %s\n", redis_ctx->errstr);
        } else {
            fprintf(stderr, "Redis connection error: can't allocate redis context\n");
        }

        goto fail;
    }

    if (password) {
        reply = redisCommand(redis_ctx, "AUTH %s", password);
        if (!reply || reply->type == REDIS_REPLY_ERROR) {
            fprintf(stderr, "Redis authentication failed %s\n", redis_ctx->errstr);
            goto fail;
        }

        freeReplyObject(reply);
    }

    return 0;
fail:
    freeReplyObject(reply);
    redisFree(redis_ctx);
    return -1;
}

int redis_cmd_int(const char *command)
{
    char cmdbuf[1024] = {'\0'};
    redisReply *reply;
    int len, retval;


    len = strlen(command) - 1;
    for (; command[len] == ' '; len--);
    memcpy(cmdbuf, command, len + 1);
    cmdbuf[sizeof(cmdbuf) - 1] = '\0';
    fprintf(stderr, "Redis cmd: \"%s\"\n", cmdbuf);

    reply = redisCommand(redis_ctx, cmdbuf);
    if (reply->type == REDIS_REPLY_ERROR) {
        fprintf(stderr, "Redis error: %s\n", reply->str);
    } else if (reply->type == REDIS_REPLY_INTEGER) {
        retval = reply->integer;
    } else if (reply->type == REDIS_REPLY_STRING) {
        retval = atoi(reply->str);
    }
    freeReplyObject(reply);

    return retval;
}

void redis_disco(void)
{
    redisFree(redis_ctx);
}
