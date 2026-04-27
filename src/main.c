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

int main(int ac, char **av)
{
    params_t params = {0};

    if (parse_args(ac, av, &params) == 84)
        return (84);
    return (0);
}
