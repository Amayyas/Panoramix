/*
** EPITECH PROJECT, 2026
** Panoramix - Criterion tests
*/

#include <criterion/criterion.h>
#include "panoramix.h"

Test(villager_suite, villager_handles_no_refill)
{
    params_t params = {1, 1, 1, 0};
    common_t common = {0};
    villager_t v = {0};

    cr_assert_eq(init_resources(&common, &params), 0);
    common.current_pot = 0;
    common.refills_left = 0;
    v.id = 0;
    v.fights_left = 1;
    v.common = &common;

    void *ret = villager_thread(&v);
    cr_assert_null(ret);

    destroy_resources(&common);
}
