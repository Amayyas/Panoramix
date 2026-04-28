/*
** EPITECH PROJECT, 2026
** Panoramix
** File description:
** setup resources
*/

#include "panoramix.h"

int init_resources(common_t *common, params_t *params)
{
    common->params = *params;
    common->current_pot = params->pot_size;
    common->refills_left = params->nb_refills;
    if (pthread_mutex_init(&common->pot_mutex, NULL) != 0)
        return (84);
    if (pthread_mutex_init(&common->print_mutex, NULL) != 0)
        return (84);
    if (sem_init(&common->druid_sleep, 0, 0) != 0)
        return (84);
    if (sem_init(&common->villager_wait, 0, 0) != 0)
        return (84);
    return (0);
}

void destroy_resources(common_t *common)
{
    pthread_mutex_destroy(&common->pot_mutex);
    pthread_mutex_destroy(&common->print_mutex);
    sem_destroy(&common->druid_sleep);
    sem_destroy(&common->villager_wait);
}
