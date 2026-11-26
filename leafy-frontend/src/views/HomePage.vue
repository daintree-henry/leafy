<template>
  <div class="page">
    <section class="section">
      <div class="section-head">
        <h3>나의 식물</h3>
        <span class="count">{{ userPlants.length }}</span>
      </div>
      <div v-if="userPlants.length" class="card-grid">
        <article v-for="userPlant in userPlants" :key="userPlant.userPlantId" class="leafy-card clickable plant-card" @click="openPlantDetail(userPlant.plant)">
          <div class="thumb">
            <img v-if="plantImage(userPlant.plant)" :src="plantImage(userPlant.plant)" :alt="userPlant.plant.plantName">
            <v-icon v-else size="40" class="thumb-icon">mdi-sprout-outline</v-icon>
          </div>
          <div class="plant-details">
            <h4 class="plant-name">{{ userPlant.plantNickname }}</h4>
            <p class="plant-type">{{ userPlant.plant ? userPlant.plant.plantName : '알 수 없는 식물' }} · {{ userPlant.plant ? userPlant.plant.plantType : '' }}</p>
            <span v-if="userPlant.waterRequired" class="chip chip-alert"><v-icon size="16">mdi-water-alert-outline</v-icon>물 줄 때가 됐어요</span>
            <span v-else class="chip chip-water"><v-icon size="16">mdi-water-check-outline</v-icon>물 충분</span>
          </div>
        </article>
      </div>
      <p v-else class="empty">아직 등록한 식물이 없습니다. Plants에서 마음에 드는 식물을 추가해 보세요.</p>
    </section>

    <section class="section">
      <div class="section-head">
        <h3>최근 일기</h3>
      </div>
      <div v-if="logs.length" class="card-grid">
        <!-- Recent diary section -->
        <article v-for="log in logs" :key="log.plantLogId" class="leafy-card log-card">
          <div class="log-top">
            <span class="log-date" :title="formatDate(log.logDate)">{{ relativeDay(log.logDate) }}</span>
            <span v-if="log.watered" class="chip chip-water"><v-icon size="16">mdi-water-check</v-icon>물 줌</span>
          </div>
          <h5 class="log-plant" @click="openPlantDetail(log.userPlant.plant)">{{ log.userPlant.plantNickname }}({{ log.userPlant.plant ? log.userPlant.plant.plantName : '알 수 없는 식물' }})</h5>
          <p class="log-note">{{ log.note }}</p>
        </article>
      </div>
      <p v-else class="empty">아직 작성한 일기가 없습니다.</p>
    </section>
    <PlantDetailModal :deleteButton="false" :isOpen="showPlantDetailModal" @update:isOpen="showPlantDetailModal = $event" :plantId="selectedPlantId"  @removed-plant="fetchPlants"  />
  </div>
</template>
<script>
import { reactive, toRefs, computed } from 'vue';
import api from '@/api/api';
import { useStore } from 'vuex';
import PlantDetailModal from '@/components/modals/PlantDetailModal.vue';
import { plantImage, loadPlantImages } from '@/utils/plantImages';
import { formatDate, relativeDay } from '@/utils/date';

export default {
  name: 'PlantlogList',
  components: {
    PlantDetailModal
  },
  setup() {
    const store = useStore();

    const state = reactive({
      logs: [],
      userPlants: [],
      showPlantDetailModal: false,
      selectedPlantId: null,
    });

    const user = computed(() => store.state.user);

    const fetchRecentLogs = async () => {
      const userId = user.value.userId;
      api.get(`/api/v1/plant-logs/recent/user/${userId}`)
        .then(response => {
          state.logs = response.data;
        })
        .catch(error => {
          console.error(error);
        });
    };

    const fetchMyPlants = async () =>{
      // Make a GET request to retrieve all plants
      const userId = user.value.userId;
      api.get(`/api/v1/user-plants/user/${userId}`)
        .then(response => {
          state.userPlants = response.data;
        })
        .catch(error => {
          console.error(error);
        });
    };

    const openPlantDetail = (plant) => {
      if (!plant) return;
      state.selectedPlantId = plant.plantId;
      state.showPlantDetailModal = true;
    };

    loadPlantImages();
    fetchRecentLogs();
    fetchMyPlants();

    return {
      ...toRefs(state),
      user,
      fetchPlants: fetchMyPlants,
      openPlantDetail,
      formatDate,
      relativeDay,
      plantImage,
    };
  },
}
</script>
<style scoped>
.plant-card .thumb {
  height: 150px;
  background-color: var(--leafy-green-soft);
}

.plant-card .thumb {
  display: flex;
  align-items: center;
  justify-content: center;
}

.thumb-icon {
  color: var(--leafy-sage);
}

.plant-card .thumb img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
}

.plant-details {
  padding: 14px 16px 16px;
}

.plant-name {
  margin: 0;
  font-size: 1.05rem;
  font-weight: 800;
}

.plant-type {
  margin: 4px 0 10px;
  font-size: 0.88rem;
  color: var(--leafy-muted);
}

.log-card {
  padding: 16px;
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.log-top {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.log-date {
  font-size: 0.8rem;
  font-weight: 700;
  color: var(--leafy-muted);
}

.log-plant {
  margin: 0;
  font-size: 0.95rem;
  font-weight: 800;
  color: var(--leafy-green);
  cursor: pointer;
}

.log-plant:hover {
  text-decoration: underline;
}

.log-note {
  margin: 0;
  font-size: 0.92rem;
  line-height: 1.5;
}
</style>
