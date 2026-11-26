<template>
  <v-dialog v-model="isDialogOpen" max-width="560px">
    <v-card v-if="plantDetail" rounded="xl" class="detail-card">
      <div class="hero">
        <img :src="plantDetail.imageUrl" :alt="plantDetail.plantName" class="plant-image">
        <button class="close-btn" title="닫기" @click="close"><v-icon size="22">mdi-close</v-icon></button>
      </div>
      <div class="detail-body">
        <div class="title-row">
          <h2 class="plant-name">{{ plantDetail.plantName }}</h2>
          <span class="chip chip-green plant-type">{{ plantDetail.plantType }}</span>
        </div>
        <p class="plant-desc">{{ plantDetail.plantDesc }}</p>
        <div class="info-grid">
          <div class="info">
            <v-icon size="20" color="#C2410C">mdi-thermometer</v-icon>
            <p class="plant-info-label">온도</p>
            <p class="value">{{ plantDetail.temperatureLow }}~{{ plantDetail.temperatureHigh }}℃</p>
          </div>
          <div class="info">
            <v-icon size="20" color="#2B6CB0">mdi-water-percent</v-icon>
            <p class="plant-info-label">습도</p>
            <p class="value">{{ plantDetail.humidityLow }}~{{ plantDetail.humidityHigh }}%</p>
          </div>
          <div class="info">
            <v-icon size="20" color="#2F6B4F">mdi-watering-can-outline</v-icon>
            <p class="plant-info-label">물 주기</p>
            <p class="value">{{ plantDetail.wateringInterval }}일</p>
          </div>
        </div>
      </div>
      <div class="button-group">
        <v-btn variant="text" @click="close">닫기</v-btn>
        <v-spacer></v-spacer>
        <v-btn v-if="deleteButton" variant="outlined" color="#B42318" @click="removePlant">삭제</v-btn>
        <v-btn v-if="deleteButton" variant="flat" color="#2F6B4F" @click="addMyPlant">내 식물 추가</v-btn>
      </div>
    </v-card>
    <v-dialog v-model="nicknameDialogOpen" max-width="380px">
      <v-card rounded="lg" class="pa-2">
        <v-card-title class="nickname-title">식물 이름 입력</v-card-title>
        <v-card-text>
          <v-text-field v-model="plantNickname" label="이름" variant="outlined" color="#2F6B4F" @keyup.enter="submitMyPlant" />
        </v-card-text>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn variant="text" @click="nicknameDialogOpen = false">취소</v-btn>
          <v-btn variant="flat" color="#2F6B4F" @click="submitMyPlant">확인</v-btn>
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

    // Tell the parent when the dialog closes by an outside click or ESC, so the same plant can be opened again
    watch(isDialogOpen, (newVal) => {
      if (!newVal && props.isOpen) {
        emit('update:isOpen', false);
      }
    });

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
.detail-card {
  overflow: hidden;
}
.hero {
  position: relative;
  aspect-ratio: 16 / 9;
  background-color: var(--leafy-green-soft);
}
.plant-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
}
.close-btn {
  position: absolute;
  top: 12px;
  right: 12px;
  width: 36px;
  height: 36px;
  border-radius: 50%;
  border: none;
  background-color: rgba(255, 255, 255, 0.9);
  cursor: pointer;
}
.detail-body {
  padding: 20px 24px 8px;
}
.title-row {
  display: flex;
  align-items: center;
  gap: 10px;
}
.plant-name {
  margin: 0;
  font-size: 1.4rem;
  font-weight: 800;
}
.plant-desc {
  margin: 10px 0 18px;
  font-size: 0.95rem;
  line-height: 1.6;
  color: var(--leafy-muted);
}
.info-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 10px;
}
.info {
  background-color: var(--leafy-bg);
  border-radius: 12px;
  padding: 12px;
  text-align: center;
}
.info p {
  margin: 0;
}
.plant-info-label {
  margin-top: 4px !important;
  font-size: 0.78rem;
  color: var(--leafy-muted);
}
.value {
  font-size: 0.95rem;
  font-weight: 700;
}
.button-group {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 16px 20px 20px;
}
.nickname-title {
  font-size: 1.05rem;
  font-weight: 800;
}
</style>
