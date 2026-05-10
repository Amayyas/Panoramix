/*
** EPITECH PROJECT, 2026
** Panoramix
** File description:
** Log analyzer issues
*/

#include <stdio.h>
#include <string.h>
#include "log_analyzer.h"

static void store_issue(stats_t *stats, const char *message)
{
    if (stats->issue_count >= MAX_ISSUES)
        return;
    strncpy(stats->issues[stats->issue_count], message, MAX_ISSUE_LEN - 1);
    stats->issues[stats->issue_count][MAX_ISSUE_LEN - 1] = '\0';
    stats->issue_count++;
}

void add_issue(stats_t *stats, int is_error, const char *message)
{
    store_issue(stats, message);
    if (is_error) {
        stats->errors++;
        fprintf(stderr, "[error] %s\n", message);
        return;
    }
    stats->warnings++;
    fprintf(stderr, "[warn] %s\n", message);
    if (stats->strict_mode)
        stats->errors++;
}
