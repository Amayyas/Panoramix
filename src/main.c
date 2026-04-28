/*
** EPITECH PROJECT, 2026
** Panoramix
** File description:
** main functions
*/

#include "panoramix.h"

static void print_usage(void)
{
    printf("USAGE: ./panoramix <nb_villagers> <pot_size> ");
    printf("<nb_fights> <nb_refills>\n");
}

int parse_args(int ac, char **av, params_t *params)
{
    if (ac != 5) {
        print_usage();
        return (84);
    }
    params->nb_villagers = atoi(av[1]);
    params->pot_size = atoi(av[2]);
    params->nb_fights = atoi(av[3]);
    params->nb_refills = atoi(av[4]);
    if (params->nb_villagers <= 0 || params->pot_size <= 0 ||
        params->nb_fights <= 0 || params->nb_refills <= 0) {
        print_usage();
        printf("Values must be >0.\n");
        return (84);
    }
    return (0);
}

static void launch_villagers(villager_t *villagers, common_t *common)
{
    for (int i = 0; i < common->params.nb_villagers; i++) {
        villagers[i].id = i;
        villagers[i].fights_left = common->params.nb_fights;
        villagers[i].common = common;
        pthread_create(&villagers[i].thread, NULL, villager_thread,
            &villagers[i]);
    }
}

int main(int ac, char **av)
{
    params_t params = {0};
    common_t common = {0};
    druid_t druid = {0};
    villager_t *villagers = NULL;

    if (parse_args(ac, av, &params) == 84 ||
        init_resources(&common, &params) == 84)
        return (84);
    druid.common = &common;
    pthread_create(&druid.thread, NULL, druid_thread, &druid);
    villagers = malloc(sizeof(villager_t) * params.nb_villagers);
    launch_villagers(villagers, &common);
    for (int i = 0; i < params.nb_villagers; i++)
        pthread_join(villagers[i].thread, NULL);
    free(villagers);
    return (0);
}
