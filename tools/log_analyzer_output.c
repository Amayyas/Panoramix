/*
** EPITECH PROJECT, 2026
** Panoramix
** File description:
** Log analyzer output
*/

#include <stdio.h>
#include "log_analyzer.h"

void print_summary(const stats_t *stats, int score)
{
    printf("Panoramix Log Analyzer\n");
    printf("======================\n");
    printf("Detected villagers     : %d\n", stats->detected_villagers);
    printf("Villager battle lines : %d\n", stats->villager_battle);
    printf("Villager sleep lines  : %d\n", stats->villager_sleep);
    printf("Refill requests       : %d\n", stats->villager_thirsty);
    printf("Druid refill lines    : %d\n", stats->druid_refill);
    printf("Druid out lines       : %d\n", stats->druid_out);
    printf("Warnings              : %d\n", stats->warnings);
    printf("Errors                : %d\n", stats->errors);
    printf("Quality score         : %d/100\n", score);
}

static void print_json_header(const stats_t *stats, int score)
{
    printf("{\n");
    printf("  \"detected_villagers\": %d,\n", stats->detected_villagers);
    printf("  \"villager_battle\": %d,\n", stats->villager_battle);
    printf("  \"villager_sleep\": %d,\n", stats->villager_sleep);
    printf("  \"villager_thirsty\": %d,\n", stats->villager_thirsty);
    printf("  \"druid_refill\": %d,\n", stats->druid_refill);
    printf("  \"druid_out\": %d,\n", stats->druid_out);
    printf("  \"warnings\": %d,\n", stats->warnings);
    printf("  \"errors\": %d,\n", stats->errors);
    printf("  \"quality_score\": %d,\n", score);
    printf("  \"status\": \"%s\",\n", stats->errors > 0 ? "KO" : "OK");
    printf("  \"issues\": [\n");
}

static void print_json_issues(const stats_t *stats)
{
    int index = 0;

    for (index = 0; index < stats->issue_count; index++) {
        printf("    \"%s\"", stats->issues[index]);
        if (index + 1 < stats->issue_count)
            printf(",");
        printf("\n");
    }
}

void print_json(const stats_t *stats, int score)
{
    print_json_header(stats, score);
    print_json_issues(stats);
    printf("  ]\n");
    printf("}\n");
}

void print_result(const stats_t *stats)
{
    if (stats->errors > 0) {
        printf("Result: KO (%d error(s), %d warning(s))\n",
            stats->errors, stats->warnings);
        return;
    }
    if (stats->warnings > 0) {
        printf("Result: OK with warnings (%d warning(s))\n", stats->warnings);
        return;
    }
    printf("Result: OK\n");
}
