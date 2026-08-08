{{
config(
materialized='incremental',
incremental_strategy='append',
unique_key='HASH_KEY'



)



}}

select * from {{ source ('btc','btc') }}

{% if is_incremental() %}
where block_timestamp > (
select max(block_timestamp) from {{ this }}

)
{% endif %}