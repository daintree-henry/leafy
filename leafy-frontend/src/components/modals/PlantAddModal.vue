<template>
  <v-dialog v-model="isDialogOpen" persistent max-width="600px">
    <v-card>
      <v-card-title class="text-center">
        <h3 style="margin-top: 20px;">식물 추가</h3>
      </v-card-title>
      <v-card-text>
        <v-container>
          <v-form ref="form" @submit.prevent="addPlant">
            <v-row>
              <v-col cols="6">
                <v-text-field
                  v-model="plantName"
                  label="식물명"
                  required
                ></v-text-field>
              </v-col>
              <v-col cols="6">
                <v-text-field
                  v-model="plantType"
                  label="식물 타입"
                  required
                ></v-text-field>
              </v-col>
              <v-col cols="12">
                <v-textarea
                  v-model="plantDesc"
                  label="식물 상세 설명"
                  required
                ></v-textarea>
              </v-col>
              <v-col cols="12">
                <v-text-field
                  v-model="imageUrl"
                  label="이미지 URL"
                  required
                ></v-text-field>
              </v-col>
              <v-col cols="12">
                <v-range-slider
                  v-model="temperatureRange"
                  :min="10"
                  :max="40"
                  step="0.1"
                  label="온도 범위"
                  thumb-label
                  tick-labels
                ></v-range-slider>
              </v-col>
              <v-col cols="12">
                <v-range-slider
                  v-model="humidityRange"
                  :min="30"
                  :max="60"
                  step="1"
                  label="습도 범위"
                  thumb-label
                  tick-labels
                ></v-range-slider>
              </v-col>
              <v-col cols="12">
                <v-text-field
                  v-model="wateringInterval"
                  label="물 주기(일)"
                  type="number"
                  required
                ></v-text-field>
              </v-col>
            </v-row>
          </v-form>
        </v-container>
      </v-card-text>
      
      <v-row align="center" justify="center">
        <v-col cols="5">
          <v-btn block size="large" color="#999999" @click="close" >취소</v-btn>
        </v-col>
        <v-col cols="5">
          <v-btn block size="large" color="#556B2F" @click="addPlant" >추가</v-btn>  
        </v-col>
      </v-row>
      <v-card-actions>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<script>
import api from '@/api/api.js';

export default {
  props: {
    isOpen: {
      type: Boolean,
      required: true,
    },
  },
  data() {
    return {
      plantName: "",
      plantType: "",
      plantDesc: "",
      imageUrl: "",
      temperatureRange: [18.0, 30.0],
      humidityRange: [40.0, 50.0],
      wateringInterval: 7,
    };
  },
  watch: {
    isOpen(newVal) {
      this.isDialogOpen = newVal;
    }
  },
  methods: {
    close() {
      this.$emit("update:isOpen", false);
    },
    async addPlant() {
      if (this.$refs.form.validate()) {
        try {
          await api.post("/api/v1/plants", {
            plantName: this.plantName,
            plantType: this.plantType,
            plantDesc: this.plantDesc,
            imageUrl: this.imageUrl,
            temperatureLow: this.temperatureRange[0],
            temperatureHigh: this.temperatureRange[1],
            humidityLow: this.humidityRange[0],
            humidityHigh: this.humidityRange[1],
            wateringInterval: this.wateringInterval,
          });
          this.$emit("added-plant");
          this.close();
        } catch (error) {
          console.error(error);
        }
      }
    },
  },
};
</script>

<style scoped>
.v-btn{
  color: white;
}
</style>
