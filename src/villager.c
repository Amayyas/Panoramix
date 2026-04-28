/*
** EPITECH PROJECT, 2026
** Panoramix
** File description:
** villager logic
*/

#include "panoramix.h"

static void handle_refill(villager_t *v)
{
    if (v->common->current_pot == 0) {
        printf("Villager %d: Hey Pano wake up! We need more potion.\n",
            v->id);
        sem_post(&v->common->druid_sleep);
        sem_wait(&v->common->villager_wait);
    }
}

void *villager_thread(void *arg)
{
    villager_t *v = (villager_t *)arg;

    printf("Villager %d: Going into battle!\n", v->id);
    while (v->fights_left > 0) {
        pthread_mutex_lock(&v->common->pot_mutex);
        printf("Villager %d: I need a drink... I see %d servings left.\n",
            v->id, v->common->current_pot);
        handle_refill(v);
        v->common->current_pot--;
        pthread_mutex_unlock(&v->common->pot_mutex);
        v->fights_left--;
        printf("Villager %d: Take that roman scum! Only %d left.\n",
            v->id, v->fights_left);
    }
    printf("Villager %d: I'm going to sleep now.\n", v->id);
    return (NULL);
}
