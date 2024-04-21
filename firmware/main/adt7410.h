#include "esp_check.h"
#include "driver/i2c.h"

#define ADT7410_ADDR 0x48
#define ADT7410_REG_TEMPERATURE 0x00
#define ADT7410_REG_STATUS 0x02
#define ADT7410_REG_ID 0x0b
#define ADT7410_STATUS_NOT_READY 0x80
#define ADT7410_CMD_RESET 0x2F

#define ADT7410_ID_MANUFACTURER 0x19

static esp_err_t adt7410_read_u8(uint8_t reg, uint8_t* value) {
  esp_err_t err = i2c_master_write_read_device(I2C_NUM_0, ADT7410_ADDR, &reg, 1, value, 1, 500 / portTICK_PERIOD_MS);
  if (err != ESP_OK) {
     printf("read failed: %s\n", esp_err_to_name(err));
  }
  return err;
}

static esp_err_t adt7410_read_u16(uint8_t reg, uint16_t* value) {
  uint8_t buffer[2];
  esp_err_t err = i2c_master_write_read_device(I2C_NUM_0, ADT7410_ADDR, &reg, 1, buffer, 2, 500 / portTICK_PERIOD_MS);
  if (err == ESP_OK) {
    *value = ((uint16_t)buffer[0] << 8) | buffer[1];
  } else {
     printf("read failed: %s\n", esp_err_to_name(err));
  }
  return err;
}

static esp_err_t adt7410_read_temperature(float* value) {
  uint8_t status;
  do {
    esp_err_t err = adt7410_read_u8(ADT7410_REG_STATUS, &status);
    ESP_RETURN_ON_ERROR(err, TAG, "status read failed");
  } while (status & ADT7410_STATUS_NOT_READY);

  uint16_t temp;
  esp_err_t err = adt7410_read_u16(ADT7410_REG_TEMPERATURE, &temp);
  ESP_RETURN_ON_ERROR(err, TAG, "temp read failed");

  *value = ((int16_t)(temp >> 3)) * .0625;
  return ESP_OK;
}

static void adt7410_reset(void) {
  uint8_t value = ADT7410_CMD_RESET;
  esp_err_t err = i2c_master_write_to_device(I2C_NUM_0, ADT7410_ADDR, &value, 1, 10 / portTICK_PERIOD_MS);
  if (err != ESP_OK) {
    printf("reset failed: %s\n", esp_err_to_name(err));
  }
}

static esp_err_t adt7410_init(void) {
  adt7410_reset();

  uint8_t value;
  esp_err_t err = adt7410_read_u8(ADT7410_REG_ID, &value);
  ESP_RETURN_ON_ERROR(err, TAG, "Reading ID register failed");

  if ((value >> 3) != ADT7410_ID_MANUFACTURER) {
    ESP_LOGE(TAG, "Invalid ID for ADT7410: 0x%02x", value);
    return ESP_FAIL;
  }
  return ESP_OK;
}

