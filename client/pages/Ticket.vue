<template>
  <div>
    <div class="hagaki">
      <p class="title">{{ event.title }}</p>
      <p class="date">{{ event.date }}</p>
      <p class="organization">{{ entry.organization }}</p>
      <p class="name">{{ entry.name }}</p>
      <img class="code" :src="qrcode" >
    </div>
  </div>
</template>

<script>
import QRCode from 'qrious'

export default {
  data () {
    return {
      event: {},
      entry: {}
    }
  },
  computed: {
    qrcode() {
      return new QRCode({ value: this.entry.id, size: 200 }).toDataURL()
    }
  },
  beforeMount () {
    this.fetchEvent()
    this.fetchEntry()
  },
  methods: {
    fetchEvent() {
      fetch(`/api/events/${this.$route.params.eventId}`).then(response => response.json()).then(results => this.event = results)
    },
    fetchEntry() {
      fetch(`/api/events/${this.$route.params.eventId}/entries/${this.$route.params.entryId}`).then(response => response.json()).then(results => this.entry = results)
    }
  }
}
</script>

<style lang="scss" scoped>
  @page {
    size: 100mm 148mm;
    width: 100mm;
    height: 148mm;
    margin: 0;
    padding: 0;
    border: 0;
  }
  @media print {
    body {
      size: 100mm 148mm;
      width: 100mm;
      height: 148mm;
      margin: 0;
      padding: 0;
      border: 0;
    }
  }
  .hagaki {
    -webkit-print-color-adjust: exact;
    background-image: url("/ticket.png");
    background-color: #333333;
    background-size: contain;
    background-repeat: no-repeat;
    text-align: center;
    width: 100mm;
    height: 148mm;
    position: relative;
  }
  .title {
    color: #ffffff;
    position: absolute;
    width: 220px;
    left: 140px;
    top: 142px;
    font-size: 1.7rem;
  }
  .date {
    color: #ffffff;
    position: absolute;
    width: 100px;
    left: 15px;
    top: 147px;
    font-size: 1.1rem;
  }
  .organization {
    color: #333333;
    position: absolute;
    top: 225px;
    left: 0;
    right: 0;
    font-size: 1.7rem;
  }
  .name {
    color: #333333;
    position: absolute;
    top: 265px;
    left: 0;
    right: 0;
    font-size: 2rem;
  }
  .code {
    display: block;
    position: absolute;
    bottom: 40px;
    margin: 0 auto;
    left: 0;
    right: 0;
  }
</style>
