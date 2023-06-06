<template>
  <v-dialog v-model="isDialogOpen" max-width="600px">
    <v-card v-if="plantDetail">
      <v-card-title class="text-center">
        <h3 style="margin-top: 20px;">식물 정보</h3>
      </v-card-title>
      <v-card-text>
        <v-container>
          <v-row>
            <v-col cols="12">
              <img :src="plantDetail.imageUrl" class="plant-image">
            </v-col>
            <v-col cols="12">
              <h2 class="plant-name">{{ plantDetail.plantName }}</h2>
              <p class="plant-type">{{ plantDetail.plantType }}</p>
              <p class="plant-desc">{{ plantDetail.plantDesc }}</p>
            </v-col>
            <v-col cols="6">
              <p class="plant-info-label">온도 범위:</p>
              <p>{{ plantDetail.temperatureLow }}℃ ~ {{ plantDetail.temperatureHigh }}℃</p>
            </v-col>
            <v-col cols="6">
              <p class="plant-info-label">습도 범위:</p>
              <p>{{ plantDetail.humidityLow }}% ~ {{ plantDetail.humidityHigh }}%</p>
            </v-col>
            <v-col cols="12">
              <p class="plant-info-label">물 주기:</p>
              <p>{{ plantDetail.wateringInterval }}일</p>
            </v-col>
          </v-row>
        </v-container>
      </v-card-text>
      <v-row class="button-group" align="center" justify="center">
        <v-col :cols="deleteButton ? 4 : 10">
          <v-btn block color="#999999" @click="close">닫기</v-btn>
        </v-col>
        <v-col v-if="deleteButton" cols="4">
          <v-btn block color="#556B2F" @click="removePlant">삭제</v-btn>
        </v-col>
        <v-col v-if="deleteButton" cols="4">
          <v-btn block color="green" @click="addMyPlant">내 식물 추가</v-btn>
        </v-col>
      </v-row>
    </v-card>
    <v-dialog v-model="nicknameDialogOpen" max-width="400px">
      <v-card>
        <v-card-title class="text-center">
          <h3>식물 이름 입력</h3>
        </v-card-title>
        <v-card-text>
          <v-text-field v-model="plantNickname" label="이름" />
        </v-card-text>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn color="green" text @click="nicknameDialogOpen = false">취소</v-btn>
          <v-btn color="green" text @click="submitMyPlant">확인</v-btn>
          <v-spacer></v-spacer>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </v-dialog>
</template>

<script>
import { ref, watch, computed } from 'vue';
import api from '@/api/api.js';
import { useStore } from 'vuex';

export default {
  props: {
    isOpen: {
      type: Boolean,
      required: true,
    },
    plantId: {
      type: Number,
      required: true,
    },
    deleteButton: {
      type: Boolean,
      defaultValue: false,
    }
  },
  emits: ['update:isOpen', 'removed-plant'],
  setup(props, { emit }) {
    const isDialogOpen = ref(false);
    const plantDetail = ref(null);
    const nicknameDialogOpen = ref(false);
    const plantNickname = ref('');

    const store = useStore();

    const user = computed(() => store.state.user);

    const close = () => {
      emit('update:isOpen', false);
    };

    const fetchPlantDetail = async () => {
      try {
        const response = await api.get(`/api/v1/plants/${props.plantId}`);
        plantDetail.value = response.data;
      } catch (error) {
        console.error(error);
      }
    };

    const removePlant = async () => {
      try {
        await api.delete(`/api/v1/plants/${props.plantId}`);
        emit('removed-plant');
        close();
      } catch (error) {
        console.error(error);
      }
    };

    const addMyPlant = async () => {
      nicknameDialogOpen.value = true;
    };

    const submitMyPlant = async () => {
      try {
        await api.post(`/api/v1/user-plants`, {
            user: {
                userId: user.value.userId
            },
            plant: {
                plantId: props.plantId
            },
            plantNickname: plantNickname.value,
          });
        emit('removed-plant');
        close();
      } catch (error) {
        console.error(error);
      }
      plantNickname.value = '';
    };

    watch(() => props.isOpen, (newVal) => {
      isDialogOpen.value = newVal;
      if (newVal) {
        fetchPlantDetail();
        nicknameDialogOpen.value = false;
      }
    });

    return {
      isDialogOpen,
      plantDetail,
      close,
      removePlant,
      addMyPlant,
      nicknameDialogOpen,
      plantNickname,
      submitMyPlant,
    };
  },
};
</script>
<style scoped>
.v-btn{
  color: white;
}

.button-group{
  margin: 1rem;
}

.plant-image {
  max-width: 80%;
  height: auto;
  object-fit: cover;
  border-radius: 5px;
  margin-bottom: 1rem;
  display: block;
  margin-left: auto;
  margin-right: auto;
}

.plant-name {
  font-size: 1.5rem;
  font-weight: bold;
  margin-bottom: 0.5rem;
}

.plant-type {
  font-size: 1.25rem;
  font-weight: normal;
  margin-bottom: 1rem;
}

.plant-desc {
  font-size: 1rem;
  margin-bottom: 1.5rem;
}

.plant-info-label {
  font-weight: bold;
}

</style>