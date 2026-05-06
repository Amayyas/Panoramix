/*
** EPITECH PROJECT, 2026
** Panoramix - Criterion tests for druid
*/

#include <criterion/criterion.h>
#include "panoramix.h"
#include <pthread.h>
#include <semaphore.h>

Test(druid_suite, refill_and_post_villager_wait)
{
    params_t params = {1, 2, 1, 1};
    common_t common = {0};

    common.params = params;
    common.current_pot = 0;
    common.refills_left = 1;
    common.stop_druid = 0;

    pthread_mutex_init(&common.pot_mutex, NULL);
    pthread_mutex_init(&common.print_mutex, NULL);
    sem_init(&common.druid_sleep, 0, 1);
    sem_init(&common.villager_wait, 0, 0);

    druid_t druid = {0};
    druid.common = &common;

    druid_thread(&druid);

    cr_assert_eq(common.refills_left, 0);
    cr_assert_eq(common.current_pot, params.pot_size);
    cr_assert_eq(sem_trywait(&common.villager_wait), 0);

    sem_destroy(&common.druid_sleep);
    sem_destroy(&common.villager_wait);
    pthread_mutex_destroy(&common.pot_mutex);
    pthread_mutex_destroy(&common.print_mutex);
}

Test(druid_suite, stop_druid_breaks_loop)
{
    params_t params = {1, 2, 1, 1};
    common_t common = {0};

    common.params = params;
    common.current_pot = 0;
    common.refills_left = 1;
    common.stop_druid = 1;

    pthread_mutex_init(&common.pot_mutex, NULL);
    pthread_mutex_init(&common.print_mutex, NULL);
    sem_init(&common.druid_sleep, 0, 1);
    sem_init(&common.villager_wait, 0, 0);

    druid_t druid = {0};
    druid.common = &common;

    druid_thread(&druid);

    cr_assert_eq(common.refills_left, 1);

    sem_destroy(&common.druid_sleep);
    sem_destroy(&common.villager_wait);
    pthread_mutex_destroy(&common.pot_mutex);
    pthread_mutex_destroy(&common.print_mutex);
}
