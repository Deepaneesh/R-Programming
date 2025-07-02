
autoplot(forecasted_values) +
  autolayer(forecasted_values$mean, series = "Forecast") +
  autolayer(train, series = "Training Data") +
  autolayer(test, series = "Test Data") +
  ggtitle("ARIMA Forecast vs Test Data") +
  xlab("Time") + ylab("Passengers") +
  theme_minimal() +
  scale_colour_manual(values = c("Forecast"="red",
                                 "Training Data"="black",
                                 "Test Data"="blue")) 



# Create time values for forecast horizon
forecast_df <- data.frame(
  Time = time(forecasted_values$mean),
  Forecast = as.numeric(forecasted_values$mean),
  Lo80 = as.numeric(forecasted_values$lower[,1]),
  Hi80 = as.numeric(forecasted_values$upper[,1]),
  Lo95 = as.numeric(forecasted_values$lower[,2]),
  Hi95 = as.numeric(forecasted_values$upper[,2])
)
test_df <- data.frame(
  Time = time(test),
  Test = as.numeric(test)
)
train_df <- data.frame(
  Time = time(forecasted_values$x),
  Train = as.numeric(forecasted_values$x)
)

library(ggplot2)

k=ggplot() +
  # 95% CI ribbon
  geom_ribbon(data = forecast_df, aes(x = Time, ymin = Lo95, ymax = Hi95), fill = "blue", alpha = 0.2) +
  # Forecast line
  geom_line(data = forecast_df, aes(x = Time, y = Forecast, color = "Forecast")) +
  # Test data line
  geom_line(data = test_df, aes(x = Time, y = Test, color = "Test Data")) +
  # Train data line
  geom_line(data = train_df, aes(x = Time, y = Train, color = "Train Data")) +
  
  scale_color_manual(values = c("Forecast" = "blue", "Test Data" = "red", "Train Data" = "black")) +
  labs(
    title = "ARIMA Forecast vs Test Data",
    x = "Time",
    y = "Passengers",
    color = "Series"
  ) +
  theme_minimal()
library(plotly)
ggplotly(k)