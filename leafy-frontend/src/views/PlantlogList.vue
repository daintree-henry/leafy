<template>
  <div class="log-container">
    <v-btn v-if="!dialog" class="add-log-btn" @click="dialog = !dialog">
      일기 추가
    </v-btn>
    <transition name="slide-fade">
      <v-card v-if="dialog" class="log-card">
        <div class="add-log-body">
          <v-card-text>
            <UserPlants :userId="user.userId" @updated-userplant-id="updateUserPlantId" />
            <v-text-field v-model="newLog.note" label="Note" required></v-text-field>
            <v-switch
              v-model="newLog.watered"
              hide-details
              label="물을 주었음"
              color="primary"
            ></v-switch>
          </v-card-text>
          <v-card-actions>
            <v-spacer></v-spacer>
            <v-btn color="blue" @click="dialog = false">Cancel</v-btn>
            <v-btn color="primary" @click="addLog">Add</v-btn>
          </v-card-actions>
        </div>
      </v-card>
    </transition>
    <v-card v-for="log in logs" :key="log.plantLogId" class="log-card" variant="outlined">
      <div class="log-header">
        <v-icon v-if="log.watered" color="indigo darken-4" large> mdi-water-check </v-icon>
        <v-icon color="#DC143C" @click="deleteLog(log.plantLogId)"> mdi-delete </v-icon>
      </div>
      <div class="log-body">
        <v-card-text class="log-title" > 
          <h5 style="color: green; font-weight: bold; cursor: pointer;" @click="openPlantDetailModal(log.userPlant.plant.plantId)">{{ log.userPlant.plantNickname }}({{ log.userPlant.plant ? log.userPlant.plant.plantName : '알 수 없는 식물' }})</h5>            {{ log.note }}
        </v-card-text>
      </div>
      <div class="log-footer">
        <v-card-text>{{ log.logDate }}</v-card-text>
      </div>
    </v-card>
    <PlantDetailModal :isOpen="showPlantDetailModal" @update:isOpen="showPlantDetailModal = $event" :plantId="selectedPlantId" />
  </div>
</template>
<script>
import { reactive, toRefs, computed } from 'vue';
import api from '@/api/api';
import PlantDetailModal from '@/components/modals/PlantDetailModal.vue';
import UserPlants from '@/components/UserPlants.vue';
import { useStore } from 'vuex';

export default {
  name: 'PlantlogList',
  components: {
    PlantDetailModal,
    UserPlants
  },
  setup() {
    const store = useStore();

    const state = reactive({
      logs: [],
      newLog: {
        userPlant: {
          userPlantId: ""
        },
        note: '',
        logDate: new Date().toISOString().slice(0, 10),
        watered: false,
      },
      dialog: false,
      showPlantDetailModal: false,
      selectedPlantId: null,
    });
    
    const user = computed(() => store.state.user);

    const fetchLogs = async () => {
      const userId = user.value.userId;
      api.get(`/api/v1/plant-logs/user/${userId}`)
        .then(response => {
          state.logs = response.data;
        })
        .catch(error => {
          console.error(error);
        });
    };

    const addLog = async () => {
      await api.post('/api/v1/plant-logs', state.newLog);
      state.dialog = false;
      state.newLog = {
        note: '',
        userPlant: {
          userPlantId: ""
        },
        logDate: new Date().toISOString().slice(0, 10),
        watered: false,
      };
      await fetchLogs();
    };

    const editLog = async (plantLogId) => {
      console.log(plantLogId);
    };

    const deleteLog = async (plantLogId) => {
      await api.delete(`/api/v1/plant-logs/${plantLogId}`);
      await fetchLogs();
    };

    const openPlantDetailModal = (plantId) => {
      state.selectedPlantId = plantId;
      state.showPlantDetailModal = true;
    };
    
    const updateUserPlantId = (newPlantId) => {
      state.newLog.userPlant.userPlantId = newPlantId;
    };

    fetchLogs();

    return {
      ...toRefs(state),
      user,
      addLog,
      editLog,
      deleteLog,
      openPlantDetailModal,
      updateUserPlantId
    };
  },
}
</script>
<style scoped>
.log-container {
  margin: 30px;
  display: flex;
  flex-direction: column;
  align-items: center;
}

.log-title {
  font-size: 20px;
  font-weight: bold;
  padding: 20px;
  border-bottom: 1px solid #e9ebee;
}

.log-actions {
  display: flex;
  justify-content: center;
  padding: 20px;
}

.log-card {
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 30px;
  width: 800px;
  max-width: 90%;
  border-radius: 10px;
  border-color: #d9d9d9;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  padding: 20px;
}

.log-header {
  display: flex;
  justify-content: flex-end;
  width: 100%;
}

.add-log-body {
  justify-content: center;
  width: 100%;
}

.log-body {
  justify-content: center;
  width: 100%;
}

.log-footer {
  display: flex;
  justify-content: flex-end;
  width: 100%;
  text-align: right;
}

.add-log-btn {
  width: 800px;
  max-width: 90%;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  bottom: 20px;
  position: relative;
  z-index: 1;
}

.add-log-btn {
  display: block;
  font-size: 1rem;
  font-weight: bold;
  color: white;
  background-color: #38a169;
  margin-left: auto;
  margin-right: auto;
  text-align: center; 
}

.slide-fade-enter-active {
  transition: all 0.7s ease-out;
}

.slide-fade-leave-active {
  transition: all 0.1s cubic-bezier(1, 0.5, 0.8, 1);
}

.slide-fade-enter-from,
.slide-fade-leave-to {
  transform: translateY(-20px);
  opacity: 0;
}
</style>