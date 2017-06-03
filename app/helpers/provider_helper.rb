module ProviderHelper
  def step_for(resto, provider)

    if provider == 'deliveroo'
      case true
        when resto[:delivery_time] == "15 - 25" || resto[:delivery_time] == "20 - 30" || resto[:delivery_time] == "10 - 20" then "step-1"
        when resto[:delivery_time] == "25 - 35" || resto[:delivery_time] == "30 - 40" then "step-2"
        when resto[:delivery_time] == "35 - 45" || resto[:delivery_time] == "40 - 50" then "step-3"
      end
    else
      case true
        when resto[:delivery_time] <= 25 && resto[:delivery_time] >= 15 then "step-1"
        when resto[:delivery_time] <= 35 && resto[:delivery_time] >= 25 then "step-2"
        when resto[:delivery_time] <= 45 && resto[:delivery_time] >= 35 then "step-3"
      end
    end
  end
end
