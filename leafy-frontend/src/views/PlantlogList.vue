<template>
  <div class="page">
    <section class="section">
      <div class="section-head">
        <h3>일기</h3>
        <span class="count">{{ logs.length }}</span>
        <div class="actions">
          <button v-if="!dialog" class="btn-primary add-log-btn" @click="dialog = !dialog"><v-icon size="18">mdi-pencil-outline</v-icon>일기 추가</button>
        </div>
      </div>

      <transition name="slide-fade">
        <div v-if="dialog" class="leafy-card add-log-card">
          <h4>새 일기</h4>
          <UserPlants :userId="user.userId" @updated-userplant-id="updateUserPlantId" />
          <v-textarea v-model="newLog.note" label="오늘의 기록" rows="2" auto-grow variant="outlined" color="#2F6B4F" required></v-textarea>
          <v-switch
            v-model="newLog.watered"
            hide-details
            label="물을 주었음"
            color="#2F6B4F"
            inset
          ></v-switch>
          <div class="form-actions">
            <v-btn variant="text" @click="dialog = false">취소</v-btn>
            <v-btn color="#2F6B4F" variant="flat" @click="addLog">추가</v-btn>
          </div>
        </div>
      </transition>

      <div v-if="logs.length" class="log-list">
        <article v-for="log in logs" :key="log.plantLogId" class="leafy-card log-card">
          <div class="log-thumb">
            <img v-if="plantImage(log.userPlant.plant)" :src="plantImage(log.userPlant.plant)" :alt="log.userPlant.plant.plantName">
            <v-icon v-else size="28" class="thumb-icon">mdi-sprout-outline</v-icon>
          </div>
          <div class="log-body">
            <div class="log-top">
              <h5 class="log-plant" @click="openPlantDetail(log.userPlant.plant)">{{ log.userPlant.plantNickname }}({{ log.userPlant.plant ? log.userPlant.plant.plantName : '알 수 없는 식물' }})</h5>
              <span class="log-date" :title="formatDate(log.logDate)">{{ relativeDay(log.logDate) }}</span>
            </div>
            <p class="log-note">{{ log.note }}</p>
            <span v-if="log.watered" class="chip chip-water"><v-icon size="16">mdi-water-check</v-icon>물 줌</span>
          </div>
          <button class="delete-btn" title="삭제" @click="deleteLog(log.plantLogId)"><v-icon size="20">mdi-trash-can-outline</v-icon></button>
        </article>
      </div>
      <p v-else-if="!dialog" class="empty">아직 작성한 일기가 없습니다.</p>
    </section>
    <PlantDetailModal :isOpen="showPlantDetailModal" @update:isOpen="showPlantDetailModal = $event" :plantId="selectedPlantId" />
  </div>
</template>
<script>
import { reactive, toRefs, computed } from 'vue';
import api from '@/api/api';
import PlantDetailModal from '@/components/modals/PlantDetailModal.vue';
import UserPlants from '@/components/UserPlants.vue';
import { useStore } from 'vuex';
import { plantImage, loadPlantImages } from '@/utils/plantImages';
import { formatDate, relativeDay, todayString } from '@/utils/date';

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
        logDate: todayString(),
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
        logDate: todayString(),
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

    const openPlantDetail = (plant) => {
      if (!plant) return;
      state.selectedPlantId = plant.plantId;
      state.showPlantDetailModal = true;
    };

    const updateUserPlantId = (newPlantId) => {
      state.newLog.userPlant.userPlantId = newPlantId;
    };

    loadPlantImages();
    fetchLogs();

    return {
      ...toRefs(state),
      user,
      addLog,
      editLog,
      deleteLog,
      openPlantDetail,
      updateUserPlantId,
      formatDate,
      relativeDay,
      plantImage,
    };
  },
}
</script>
<style scoped>
.add-log-card {
  padding: 20px;
  margin-bottom: 20px;
}

.add-log-card h4 {
  margin: 0 0 12px;
  font-size: 1rem;
  font-weight: 800;
}

.form-actions {
  display: flex;
  justify-content: flex-end;
  gap: 8px;
  margin-top: 8px;
}

.log-list {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.log-card {
  display: flex;
  align-items: flex-start;
  gap: 16px;
  padding: 14px;
}

.log-thumb {
  flex: 0 0 64px;
  height: 64px;
  border-radius: 12px;
  overflow: hidden;
  background-color: var(--leafy-green-soft);
}

.log-thumb {
  display: flex;
  align-items: center;
  justify-content: center;
}

.thumb-icon {
  color: var(--leafy-sage);
}

.log-thumb img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
}

.log-body {
  flex: 1;
  min-width: 0;
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  gap: 6px;
}

.log-top {
  width: 100%;
  display: flex;
  align-items: baseline;
  gap: 10px;
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

.log-date {
  font-size: 0.8rem;
  font-weight: 600;
  color: var(--leafy-muted);
}

.log-note {
  margin: 0;
  font-size: 0.93rem;
  line-height: 1.5;
}

.delete-btn {
  background: none;
  border: none;
  color: var(--leafy-muted);
  border-radius: 8px;
  padding: 6px;
  cursor: pointer;
}

.delete-btn:hover {
  color: #B42318;
  background-color: #FDECEA;
}

.slide-fade-enter-active,
.slide-fade-leave-active {
  transition: all 0.2s ease;
}

.slide-fade-enter-from,
.slide-fade-leave-to {
  transform: translateY(-8px);
  opacity: 0;
}
</style>
