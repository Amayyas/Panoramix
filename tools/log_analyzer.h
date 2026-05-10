/*
** EPITECH PROJECT, 2026
** Panoramix
** File description:
** Log analyzer header
*/

#ifndef PANORAMIX_LOG_ANALYZER_H
    #define PANORAMIX_LOG_ANALYZER_H

    #define MAX_VILLAGER_ID 10000
    #define MAX_ISSUES 256
    #define MAX_ISSUE_LEN 256

typedef struct villager_s {
    int seen;
    int battle_count;
    int sleep_count;
    int thirsty_count;
    int first_battle_line;
    int first_sleep_line;
} villager_t;

typedef struct stats_s {
    int villager_battle;
    int villager_sleep;
    int villager_thirsty;
    int druid_refill;
    int druid_out;
    int detected_villagers;
    int warnings;
    int errors;
    int strict_mode;
    int issue_count;
    char issues[MAX_ISSUES][MAX_ISSUE_LEN];
    villager_t villagers[MAX_VILLAGER_ID];
} stats_t;

typedef struct args_s {
    const char *log_file;
    int expected_villagers;
    int max_refills;
    int json_mode;
    int strict_mode;
} args_t;

int analyze_file(const char *path, stats_t *stats);
void check_invariants(stats_t *stats, const args_t *args);
int compute_score(const stats_t *stats);
void print_summary(const stats_t *stats, int score);
void print_json(const stats_t *stats, int score);
void print_result(const stats_t *stats);
void add_issue(stats_t *stats, int is_error, const char *message);

#endif /* !PANORAMIX_LOG_ANALYZER_H */
