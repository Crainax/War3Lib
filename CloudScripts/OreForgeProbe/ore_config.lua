-- Dedicated test map ONLY. No Xlimon archive keys or production environment.
return {
    ore_key = 'OFPOre', -- platform COUNT item used as lifetime acquired total
    archive_field = 'war3lib_ore_forge_probe_v1',
    allowed_env = {[-1] = true, [1] = true, [2] = true},
    max_stones = 25,
    max_total = 1000000000,
    max_archive_bytes = 60000,
}
