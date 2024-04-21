static const char* TAG = "main";

#include "driver/gpio.h"
#include "driver/i2c.h"
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "adt7410.h"
#include <stdio.h>

#define PIN_LED_1 GPIO_NUM_4
#define PIN_LED_2 GPIO_NUM_5

#define PIN_I2C_SDA GPIO_NUM_6
#define PIN_I2C_SCL GPIO_NUM_7

void led_init(void) {
  gpio_config_t config = {
      .mode = GPIO_MODE_OUTPUT,
      .pull_up_en = GPIO_PULLUP_DISABLE,
      .pull_down_en = GPIO_PULLUP_DISABLE,
      .pin_bit_mask = (1 << PIN_LED_1) | (1 << PIN_LED_2),
  };
  ESP_ERROR_CHECK(gpio_config(&config));
}

void i2c_init(void) {
  i2c_config_t config = {
      .mode = I2C_MODE_MASTER,
      .sda_io_num = PIN_I2C_SDA,
      .scl_io_num = PIN_I2C_SCL,
      .sda_pullup_en = GPIO_PULLUP_DISABLE,
      .scl_pullup_en = GPIO_PULLUP_DISABLE,
      .master.clk_speed = 100000,
      .clk_flags = 0,
  };

  ESP_ERROR_CHECK(i2c_param_config(I2C_NUM_0, &config));
  ESP_ERROR_CHECK(i2c_driver_install(I2C_NUM_0, I2C_MODE_MASTER, 0, 0, 0));
}

void app_main(void) {
  printf("Hello world!\n");

  led_init();
  i2c_init();
  esp_err_t err = adt7410_init();

  for (;;) {
    float temp;
    err = adt7410_read_temperature(&temp);
    if (err == ESP_OK) {
      printf("Temp: %f\n", temp);
    }

    gpio_set_level(PIN_LED_1, 1);
    gpio_set_level(PIN_LED_2, 0);
    vTaskDelay(500 / portTICK_PERIOD_MS);
    gpio_set_level(PIN_LED_1, 0);
    gpio_set_level(PIN_LED_2, 1);
    vTaskDelay(500 / portTICK_PERIOD_MS);
  }
}
