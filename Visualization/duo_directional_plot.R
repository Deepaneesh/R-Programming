ggplot(df, aes(x = Category, y = Value, fill = Color)) +
  
  # Bars
  geom_bar(stat = "identity", width = 0.7) +
  
  # Value labels inside bars
  geom_text(
    aes(label = Value),
    position = position_stack(vjust = 0.5),
    color = "white",
    size = 5,
    fontface = "bold"
  ) +
  
  # Category labels near center line
  geom_text(
    aes(
      y = ifelse(Value < 0, 0.8, -0.8),
      label = Category
    ),
    color = "black",
    size = 5,
    fontface = "bold"
  ) +
  
  # Colors
  scale_fill_manual(values = c(
    "Negative" = "red",
    "Positive" = "green"
  )) +
  
  # Zero line
  geom_hline(yintercept = 0,
             color = "black",
             linewidth = 0.5) +
  
  # Flip chart
  coord_flip() +
  
  # Clean white background
  theme_classic() +
  
  # Remove axes and grids
  theme(
    panel.grid = element_blank(),
    legend.position = "none",
    
    axis.title = element_blank(),
    axis.line = element_blank(),
    axis.ticks = element_blank(),
    
    # Remove axis labels
    axis.text.x = element_blank(),
    axis.text.y = element_blank(),
    
    plot.background = element_rect(
      fill = "white",
      color = NA
    ),
    
    panel.background = element_rect(
      fill = "white",
      color = NA
    )
  )
