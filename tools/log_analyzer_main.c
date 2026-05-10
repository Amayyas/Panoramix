/*
** EPITECH PROJECT, 2026
** Panoramix
** File description:
** Log analyzer main
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "log_analyzer.h"

static int parse_positive(const char *value)
{
    char *end = NULL;
    long parsed = strtol(value, &end, 10);

    if (end == value || *end != '\0')
        return -1;
    if (parsed <= 0 || parsed > 1000000)
        return -1;
    return (int)parsed;
}

static int parse_token(const char *token, args_t *args)
{
    if (strcmp(token, "--json") == 0) {
        args->json_mode = 1;
        return 0;
    }
    if (strcmp(token, "--strict") == 0) {
        args->strict_mode = 1;
        return 0;
    }
    return 84;
}

static int parse_numeric_token(const char *token, args_t *args)
{
    int parsed = 0;

    parsed = parse_positive(token);
    if (parsed < 0)
        return 84;
    if (args->expected_villagers == 0) {
        args->expected_villagers = parsed;
        return 0;
    }
    if (args->max_refills == 0) {
        args->max_refills = parsed;
        return 0;
    }
    return 84;
}

static int parse_args(int argc, char **argv, args_t *args)
{
    int index = 0;

    args->log_file = argv[1];
    for (index = 2; index < argc; index++) {
        if (parse_token(argv[index], args) == 0)
            continue;
        if (parse_numeric_token(argv[index], args) != 0)
            return 84;
    }
    return 0;
}

static void print_usage(const char *name)
{
    fprintf(stderr, "Usage: %s <log_file> [expected_villagers] ", name);
    fprintf(stderr, "[max_refills] [--json] [--strict]\n");
}

static int run_analyzer(const args_t *args)
{
    stats_t stats = {0};
    int score = 0;

    stats.strict_mode = args->strict_mode;
    if (analyze_file(args->log_file, &stats) != 0)
        return 84;
    check_invariants(&stats, args);
    score = compute_score(&stats);
    if (args->json_mode)
        print_json(&stats, score);
    else {
        print_summary(&stats, score);
        print_result(&stats);
    }
    if (stats.errors > 0)
        return 1;
    return 0;
}

int main(int argc, char **argv)
{
    args_t args = {0};

    if (argc < 2) {
        print_usage(argv[0]);
        return 84;
    }
    if (parse_args(argc, argv, &args) != 0) {
        print_usage(argv[0]);
        return 84;
    }
    return run_analyzer(&args);
}
