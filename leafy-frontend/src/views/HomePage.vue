<template>
  <div>
    <h3 style="margin-top: 15px;">나의 식물</h3>
    <div class="plant-list">
      <div v-for="userPlant in userPlants" :key="userPlant.userPlantId" class="plant-item" @click="openPlantDetailModal(userPlant.plant.plantId)">
        <v-icon v-if="userPlant.waterRequired" color="red darken-4" large> mdi-water-alert-outline </v-icon>
        <v-icon v-if="!userPlant.waterRequired" color="blue darken-4" large> mdi-water-check-outline </v-icon>
        
        
        <div class="plant-details">
          <h5 style="color: green; font-weight: bold; cursor: pointer;" class="plant-name">{{ userPlant.plantNickname }}({{ userPlant.plant ? userPlant.plant.plantName : '알 수 없는 식물' }})</h5>
          <p class="plant-type">{{ userPlant.plant ? userPlant.plant.plantType : '알 수 없는 식물' }}</p>
        </div>
      </div>
    </div>
      
    <h3>최근 일기</h3>
    <div class="log-container">
      <v-card v-for="log in logs" :key="log.plantLogId" class="log-card" variant="outlined">
        <div class="log-header">
          <v-icon v-if="log.watered" color="indigo darken-4" large> mdi-water-check </v-icon>
        </div>
        <div class="log-body">
          <v-card-text class="log-title" > 
<!-- 최근 일기 부분 -->
<h5 style="color: green; font-weight: bold; cursor: pointer;" @click="openPlantDetailModal(log.userPlant.plant.plantId)">{{ log.userPlant.plantNickname }}({{ log.userPlant.plant ? log.userPlant.plant.plantName : '알 수 없는 식물' }})</h5>              {{ log.note }}
          </v-card-text>
        </div>
        <div class="log-footer">
          <v-card-text>{{ log.logDate }}</v-card-text>
        </div>
      </v-card>
    </div>
    <PlantDetailModal :deleteButton="false" :isOpen="showPlantDetailModal" @update:isOpen="showPlantDetailModal = $event" :plantId="selectedPlantId"  @removed-plant="fetchPlants"  />
  </div>
</template>
<script>
import { reactive, toRefs, computed } from 'vue';
import api from '@/api/api';
import { useStore } from 'vuex';
import PlantDetailModal from '@/components/modals/PlantDetailModal.vue';

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

    const openPlantDetailModal = (plantId) => {
      state.selectedPlantId = plantId;
      state.showPlantDetailModal = true;
    };
    
    fetchRecentLogs();
    fetchMyPlants();

    return {
      ...toRefs(state),
      user,
      openPlantDetailModal,
    };
  },
}
</script>
<style scoped>
/* 나의 식물 스타일 */
.plant-list {
  margin: 30px;
  display: flex;
  flex-wrap: wrap;
  justify-content: center;
}

.plant-item {
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 30px;
  margin-left: 10px;
  margin-right: 10px;
  width: 280px;
  height: 150px;
  border-radius: 10px;
  border: 1px solid #d9d9d9;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  padding: 20px;
  cursor: pointer;
}

.plant-details {  
  display: flex;
  flex-direction: column;
  margin-top: auto; /* 추가된 속성 */
  margin-bottom: auto; /* 추가된 속성 */
}


.plant-name {
  font-weight: bold;
}

.plant-type {
  font-size: 16px;
  color: #4c4c4c;
}

.log-container {
  margin: 30px;
  display: flex;
  flex-wrap: wrap;
  justify-content: center;
}

.log-card {
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 30px;
  margin-left: 10px;
  margin-right: 10px;
  width: 280px;
  border-radius: 10px;
  border-color: #d9d9d9;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  padding: 20px;
}
</style>
