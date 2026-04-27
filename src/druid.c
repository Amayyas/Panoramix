/*
** EPITECH PROJECT, 2026
** Panoramix
** File description:
** druid logic
*/

#include "panoramix.h"

void *druid_thread(void *arg)
{
    druid_t *druid = (druid_t *)arg;

    printf("Druid: I'm ready... but sleepy...\n");
    while (druid->common->refills_left > 0) {
        sem_wait(&druid->common->druid_sleep);
        druid->common->current_pot = druid->common->params.pot_size;
        druid->common->refills_left--;
        printf("Druid: Ah! Yes, yes, I'm awake! Working on it! ");
        printf("Beware I can only make %d more refills after this one.\n",
            druid->common->refills_left);
        if (druid->common->refills_left == 0)
            printf("Druid: I'm out of viscum. I'm going back to... zZz\n");
        sem_post(&druid->common->villager_wait);
    }
    return (NULL);
}
