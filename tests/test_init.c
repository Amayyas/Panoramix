/*
** EPITECH PROJECT, 2026
** Panoramix - Criterion tests
*/

#include <criterion/criterion.h>
#include "panoramix.h"

Test(init_resources_suite, init_and_destroy_resources)
{
    params_t params = {3, 5, 2, 1};
    common_t common = {0};

    cr_assert_eq(init_resources(&common, &params), 0);
    cr_assert_eq(common.params.nb_villagers, 3);
    cr_assert_eq(common.params.pot_size, 5);
    cr_assert_eq(common.params.nb_fights, 2);
    cr_assert_eq(common.params.nb_refills, 1);
    cr_assert_eq(common.current_pot, 5);
    cr_assert_eq(common.refills_left, 1);
    destroy_resources(&common);
}