/*
** EPITECH PROJECT, 2026
** Panoramix - Criterion tests
*/

#include <criterion/criterion.h>
#include "panoramix.h"

Test(parse_args_suite, valid_arguments)
{
    char *argv[] = {"./panoramix", "3", "5", "2", "1", NULL};
    params_t params = {0};

    int ret = parse_args(5, argv, &params);
    cr_assert_eq(ret, 0);
    cr_assert_eq(params.nb_villagers, 3);
    cr_assert_eq(params.pot_size, 5);
    cr_assert_eq(params.nb_fights, 2);
    cr_assert_eq(params.nb_refills, 1);
}

Test(parse_args_suite, wrong_arg_count)
{
    char *argv[] = {"./panoramix", "3", NULL};
    params_t params = {0};

    int ret = parse_args(2, argv, &params);
    cr_assert_eq(ret, 84);
}

Test(parse_args_suite, non_positive_values)
{
    char *argv[] = {"./panoramix", "0", "5", "2", "1", NULL};
    params_t params = {0};

    int ret = parse_args(5, argv, &params);
    cr_assert_eq(ret, 84);
}
