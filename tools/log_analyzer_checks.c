/*
** EPITECH PROJECT, 2026
** Panoramix
** File description:
** Log analyzer checks
*/

#include <stdio.h>
#include "log_analyzer.h"

static void check_global(stats_t *stats, const args_t *args)
{
    if (args->expected_villagers > 0
        && stats->detected_villagers != args->expected_villagers)
        add_issue(stats, 1, "Unexpected number of detected villagers");
    if (args->max_refills > 0 && stats->druid_refill > args->max_refills)
        add_issue(stats, 1, "Druid refill lines exceed max_refills");
}

static void check_global_consistency(stats_t *stats)
{
    if (stats->villager_sleep > stats->villager_battle)
        add_issue(stats, 1, "More sleep lines than battle lines");
    if (stats->druid_out > 1)
        add_issue(stats, 0, "Druid out line appears more than once");
    if (stats->villager_thirsty < stats->druid_refill)
        add_issue(stats, 0, "Refill lines are greater than wake-up requests");
}

static void check_one_villager(stats_t *stats, int id, const args_t *args)
{
    villager_t *villager = &stats->villagers[id];

    if (!villager->seen)
        return;
    if (args->expected_villagers > 0 && id >= args->expected_villagers)
        add_issue(stats, 1, "A villager id is outside expected range");
    if (villager->battle_count == 0)
        add_issue(stats, 1, "A villager has no battle line");
    if (villager->sleep_count == 0)
        add_issue(stats, 1, "A villager has no sleep line");
    if (villager->battle_count > 1)
        add_issue(stats, 0, "A villager has duplicate battle lines");
    if (villager->sleep_count > 1)
        add_issue(stats, 0, "A villager has duplicate sleep lines");
}

static void check_sequence(stats_t *stats, int id)
{
    villager_t *villager = &stats->villagers[id];

    if (!villager->seen)
        return;
    if (villager->first_battle_line == 0 || villager->first_sleep_line == 0)
        return;
    if (villager->first_sleep_line < villager->first_battle_line)
        add_issue(stats, 1, "A villager sleeps before first battle");
}

void check_invariants(stats_t *stats, const args_t *args)
{
    int id = 0;

    check_global(stats, args);
    check_global_consistency(stats);
    for (id = 0; id < MAX_VILLAGER_ID; id++) {
        check_one_villager(stats, id, args);
        check_sequence(stats, id);
    }
}

int compute_score(const stats_t *stats)
{
    int score = 100 - (stats->errors * 20) - (stats->warnings * 5);

    if (score < 0)
        return 0;
    return score;
}
