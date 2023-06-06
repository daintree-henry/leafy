<template>
  <div class="container">
    <div class="plant-list">
      <div v-for="plant in plants" :key="plant.plantId" class="plant-item" @click="openPlantDetailModal(plant.plantId)">
        <img :src="plant.imageUrl" :alt="plant.plantName" class="plant-image">
        <div class="plant-details">
          <h2 class="plant-name">{{ plant.plantName }}</h2>
          <p class="plant-type">{{ plant.plantType }}</p>
          <p class="plant-desc">{{ plant.plantDesc }}</p>
        </div>
      </div>
    </div>
    <button class="add-plant-button" @click="openPlantAddModal">식물 추가</button>

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
.container {
  max-width: 1200px;
  margin: 40px auto;
}

.title {
  font-size: 2.5rem;
  margin-top: 2rem;
  margin-bottom: 1.5rem;
}

.plant-list {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  grid-gap: 2rem;
}

.plant-item {
  border: 1px solid #eee;
  border-radius: 8px;
  overflow: hidden;
  cursor: pointer;
}

.plant-image {
  width: 100%;
  height: 200px;
  object-fit: cover;
}

.plant-details {
  padding: 1rem;
}

.plant-name {
  font-size: 1.5rem;
  margin-bottom: 0.5rem;
}

.plant-type {
  font-size: 1.2rem;
  color: #777;
}

.add-plant-button {
  display: block;
  margin-top: 2rem;
  margin-bottom: 2rem;
  padding: 0.7rem;
  font-size: 1rem;
  font-weight: bold;
  color: white;
  background-color: #38a169;
  border: none;
  border-radius: 0.25rem;
  cursor: pointer;
  
  width: 60%; 
  margin-left: auto;
  margin-right: auto;
  text-align: center; 
}
</style>
