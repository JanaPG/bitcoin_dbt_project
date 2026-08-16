with whale as (select
output_address,
sum(output_value) as total_sent,
count(*) as tx_count

from {{ ref('stg_btc_transactions')}}

where output_value > 10

group by output_address
order by total_sent desc
),
 latest as (
select * 
from {{ref('btc_usd_max')}}
where to_date(replace(event_date,' UTC','')) = current_date()-1

)
select 
w.output_address,
w.total_sent,
w.tx_count,
(p.close_price_usd * w.total_sent) as total_sent_usd
from WHALE w
cross join LATEST p