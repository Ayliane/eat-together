module ProviderHelper
  def step_for(resto, provider)

    if provider == 'deliveroo'
      case resto[:delivery_time]
        when "15 - 25" then "step1"
        when "25 - 35" then "step2"
        when "35 - 45" then "step3"
      end
    else
      case true
        when resto[:delivery_time] <= 25 && resto[:delivery_time] >= 15 then "step1"
        when resto[:delivery_time] <= 35 && resto[:delivery_time] >= 25 then "step2"
        when resto[:delivery_time] <= 45 && resto[:delivery_time] >= 35 then "step3"
      end
    end
  end
end
