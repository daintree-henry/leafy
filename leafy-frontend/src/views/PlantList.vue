<template>
  <div class="page">
    <section class="section">
      <div class="section-head">
        <h3>전체 식물</h3>
        <span class="count">{{ plants.length }}</span>
        <div class="actions">
          <button class="btn-primary add-plant-button" @click="openPlantAddModal"><v-icon size="18">mdi-plus</v-icon>식물 추가</button>
        </div>
      </div>
      <div class="card-grid">
        <article v-for="plant in plants" :key="plant.plantId" class="leafy-card clickable plant-item" @click="openPlantDetailModal(plant.plantId)">
          <div class="thumb">
            <img :src="plant.imageUrl" :alt="plant.plantName" class="plant-image">
          </div>
          <div class="plant-details">
            <div class="title-row">
              <h4 class="plant-name">{{ plant.plantName }}</h4>
              <span class="chip chip-green plant-type">{{ plant.plantType }}</span>
            </div>
            <p class="plant-desc">{{ plant.plantDesc }}</p>
          </div>
        </article>
      </div>
    </section>

    <PlantAddModal :isOpen="showPlantAddModal" @update:isOpen="showPlantAddModal = $event" @added-plant="fetchPlants" />
    <PlantDetailModal :deleteButton="true" :isOpen="showPlantDetailModal" @update:isOpen="showPlantDetailModal = $event" :plantId="selectedPlantId"  @removed-plant="fetchPlants"  />
  </div>
</template>

<script>
import api from '@/api/api';
import PlantAddModal from '@/components/modals/PlantAddModal.vue';
import PlantDetailModal from '@/components/modals/PlantDetailModal.vue';

export default {
  name: 'PlantList',
  components: {
    PlantAddModal,
    PlantDetailModal,
  },
  data() {
    return {
      plants: [],
      showPlantAddModal: false,
      showPlantDetailModal: false,
      selectedPlantId: null,
    };
  },
  mounted() {
    this.fetchPlants();
  },
  methods: {
    fetchPlants() {
      // Make a GET request to retrieve all plants
      api.get('/api/v1/plants')
        .then(response => {
          this.plants = response.data;
        })
        .catch(error => {
          console.error(error);
        });
    },
    openPlantAddModal() {
      this.showPlantAddModal = true;
    },
    openPlantDetailModal(plantId) {
      this.selectedPlantId = plantId;
      this.showPlantDetailModal = true;
    },
  },
};
</script>

<style scoped>
.thumb {
  aspect-ratio: 4 / 3;
  background-color: var(--leafy-green-soft);
}

.plant-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
}

.plant-details {
  padding: 14px 16px 18px;
}

.title-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 8px;
}

.plant-name {
  margin: 0;
  font-size: 1.05rem;
  font-weight: 800;
}

.plant-desc {
  margin: 8px 0 0;
  font-size: 0.88rem;
  line-height: 1.5;
  color: var(--leafy-muted);
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}
</style>
