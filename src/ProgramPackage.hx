private typedef Data = firedancer.vm.ProgramPackage;

@:expose("FiredancerVM.ProgramPackage")
class ProgramPackage {
	final data: Data;

	public static function fromString(s: String): ProgramPackage {
		return new ProgramPackage(Data.fromString(s));
	}

	function new(data: Data)
		this.data = data;

	public function getProgramById(id: Int): firedancer.vm.Program
		return this.data.getProgramById(id);

	public function getProgramByName(name: String): firedancer.vm.Program
		return this.data.getProgramByName(name);
}
