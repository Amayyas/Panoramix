/*
** EPITECH PROJECT, 2026
** Panoramix
** File description:
** Log analyzer parsing
*/

#include <stdio.h>
#include <string.h>
#include "log_analyzer.h"

static int contains(const char *line, const char *needle)
{
    return strstr(line, needle) != NULL;
}

static void update_global(stats_t *stats, const char *line)
{
    if (contains(line, "Druid: Ah! Yes, yes, I'm awake! Working on it!"))
        stats->druid_refill++;
    if (contains(line, "Druid: I'm out of viscum. I'm going back to... zZz"))
        stats->druid_out++;
}

static void update_villager(stats_t *stats, int id, const char *line, int no)
{
    villager_t *villager = &stats->villagers[id];

    if (!villager->seen) {
        villager->seen = 1;
        stats->detected_villagers++;
    }
    if (contains(line, ": Going into battle!")) {
        stats->villager_battle++;
        villager->battle_count++;
        if (villager->first_battle_line == 0)
            villager->first_battle_line = no;
    }
    if (contains(line, ": I'm going to sleep now.")) {
        stats->villager_sleep++;
        villager->sleep_count++;
        if (villager->first_sleep_line == 0)
            villager->first_sleep_line = no;
    }
}

static void update_thirsty(stats_t *stats, int id, const char *line)
{
    villager_t *villager = &stats->villagers[id];

    if (!contains(line, ": Hey Pano wake up! We need more potion."))
        return;
    stats->villager_thirsty++;
    villager->thirsty_count++;
}

static void update_line(stats_t *stats, const char *line, int line_no)
{
    char message[MAX_ISSUE_LEN];
    int villager_id = -1;

    update_global(stats, line);
    if (sscanf(line, "Villager %d:", &villager_id) != 1)
        return;
    if (villager_id < 0 || villager_id >= MAX_VILLAGER_ID) {
        snprintf(message, MAX_ISSUE_LEN,
            "Invalid villager id in log at line %d", line_no);
        add_issue(stats, 1, message);
        return;
    }
    update_villager(stats, villager_id, line, line_no);
    update_thirsty(stats, villager_id, line);
}

int analyze_file(const char *path, stats_t *stats)
{
    char line[2048];
    int line_no = 0;
    FILE *file = fopen(path, "r");

    if (file == NULL)
        return 84;
    while (fgets(line, sizeof(line), file) != NULL) {
        line_no++;
        update_line(stats, line, line_no);
    }
    fclose(file);
    return 0;
}
