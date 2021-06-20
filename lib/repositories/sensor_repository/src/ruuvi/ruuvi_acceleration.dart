class RuuviAcceleration {
  /* acceleration x axis in mg */
  final int accelerationX;

  /* acceleration y axis in mg */
  final int accelerationY;

  /* acceleration z axis in mg */
  final int accelerationZ;

  const RuuviAcceleration({
    this.accelerationX = 0,
    this.accelerationY = 0,
    this.accelerationZ = 0,
  });

  @override
  String toString() {
    return "accelerationX: $accelerationX, accelerationY: $accelerationY, accelerationZ: $accelerationZ";
  }
}
