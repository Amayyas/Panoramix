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

typedef struct params_s {
    int nb_villagers;
    int pot_size;
    int nb_fights;
    int nb_refills;
} params_t;

int parse_args(int ac, char **av, params_t *params);

#endif /* !PANORAMIX_H_ */
