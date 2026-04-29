/*
** EPITECH PROJECT, 2026
** Panoramix
** File description:
** header file
*/

#ifndef PANORAMIX_H_
    #define PANORAMIX_H_

    #include <stdio.h>
    #include <stdlib.h>
    #include <pthread.h>
    #include <semaphore.h>

typedef struct params_s {
    int nb_villagers;
    int pot_size;
    int nb_fights;
    int nb_refills;
} params_t;

typedef struct common_s {
    params_t params;
    int current_pot;
    int refills_left;
    int stop_druid;
    pthread_mutex_t pot_mutex;
    pthread_mutex_t print_mutex;
    sem_t druid_sleep;
    sem_t villager_wait;
} common_t;

typedef struct villager_s {
    int id;
    int fights_left;
    pthread_t thread;
    common_t *common;
} villager_t;

typedef struct druid_s {
    pthread_t thread;
    common_t *common;
} druid_t;

int parse_args(int ac, char **av, params_t *params);
int init_resources(common_t *common, params_t *params);
void destroy_resources(common_t *common);
void *druid_thread(void *arg);
void *villager_thread(void *arg);

#endif /* !PANORAMIX_H_ */
