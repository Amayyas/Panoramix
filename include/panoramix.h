/*
** EPITECH PROJECT, 2026
** Panoramix
** File description:
** header file
*/

#ifndef PANORAMIX_H_
    #define PANORAMIX_H_

/**
 * @file panoramix.h
 * @brief Main declarations for the Panoramix simulation.
 *
 * This file contains data structures and prototypes
 * for the druid and villager threads.
 */

    #include <stdio.h>
    #include <stdlib.h>
    #include <pthread.h>
    #include <semaphore.h>

/**
 * @brief Simulation input parameters.
 */
typedef struct params_s {
    int nb_villagers; /**< Total number of villagers. */
    int pot_size;     /**< Pot maximum capacity. */
    int nb_fights;    /**< Fights per villager. */
    int nb_refills;   /**< Max refills allowed. */
} params_t;

/**
 * @brief Shared data between all threads.
 */
typedef struct common_s {
    params_t params;           /**< Initial parameters. */
    int current_pot;           /**< Current potion left. */
    int refills_left;          /**< Remaining refills. */
    int stop_druid;            /**< Flag to stop druid. */
    pthread_mutex_t pot_mutex; /**< Pot mutex. */
    pthread_mutex_t print_mutex;/**< Print mutex. */
    sem_t druid_sleep;         /**< Druid semaphore. */
    sem_t villager_wait;       /**< Villagers semaphore. */
} common_t;

/**
 * @brief Structure representing a villager.
 */
typedef struct villager_s {
    int id;               /**< Unique ID (0 to N-1). */
    int fights_left;      /**< Remaining fights. */
    pthread_t thread;     /**< Villager thread. */
    common_t *common;     /**< Shared data pointer. */
} villager_t;

/**
 * @brief Structure representing the druid.
 */
typedef struct druid_s {
    pthread_t thread;     /**< Druid thread. */
    common_t *common;     /**< Shared data pointer. */
} druid_t;

/**
 * @brief Parse command line arguments.
 *
 * @param ac Number of arguments.
 * @param av Array containing the arguments.
 * @param params Pointer to the struct to fill.
 * @return 0 on success, 84 on error.
 */
int parse_args(int ac, char **av, params_t *params);

/**
 * @brief Initialize shared resources.
 *
 * @param common Pointer to the struct to initialize.
 * @param params Pointer to the parameters.
 * @return 0 on success, 84 on failure.
 */
int init_resources(common_t *common, params_t *params);

/**
 * @brief Destroy and free shared resources.
 *
 * @param common Pointer to the struct to clean up.
 */
void destroy_resources(common_t *common);

/**
 * @brief Main function for the druid thread.
 *
 * Refills the pot and notifies villagers.
 * Stops when no more ingredients are left.
 *
 * @param arg Pointer to the druid_t struct.
 * @return Always NULL.
 */
void *druid_thread(void *arg);

/**
 * @brief Main function for villager threads.
 *
 * Fights, then drinks the potion.
 * If pot is empty, wakes up the druid.
 *
 * @param arg Pointer to the villager_t struct.
 * @return Always NULL.
 */
void *villager_thread(void *arg);

#endif /* !PANORAMIX_H_ */
