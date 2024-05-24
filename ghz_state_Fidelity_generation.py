#from qiskit import QuantumCircuit, execute, IBMQ, Aer
from qiskit import QuantumCircuit, IBMQ, Aer
from qiskit import execute
from qiskit_experiments.framework import BatchExperiment
from qiskit_experiments.library import StateTomography
from qiskit.quantum_info import state_fidelity, Statevector
from qiskit import QuantumCircuit, Aer
from qiskit.providers.ibmq import IBMQ
from qiskit.tools.monitor import job_monitor
from qiskit.providers.aer import AerSimulator

# Your other code remains the same


# Load IBM Q account
IBMQ.load_account()
provider = IBMQ.get_provider(hub='ibm-q', group='open', project='main')

# Function to create a GHZ state
def create_ghz_circuit(num_qubits=4):
    qc = QuantumCircuit(num_qubits, num_qubits)
    qc.h(0)
    for i in range(num_qubits - 1):
        qc.cx(i, i + 1)
    return qc

ghz_circuit = create_ghz_circuit()

# Select a backend
backend = Aer.get_backend('aer_simulator')

# Prepare state tomography experiment to reconstruct the quantum state
tomography_exp = StateTomography(ghz_circuit)
experiment = BatchExperiment([tomography_exp])

# Run the experiment
result = experiment.run(backend).block_for_results()

# Retrieve the state tomography data
tomo_result = result.component_experiment_data(0)

# Perform state tomography analysis
fitted_state = tomo_result.analysis_results("state").value

# Assuming the ideal GHZ state
ideal_state = Statevector.from_label('0' * 4) + Statevector.from_label('1' * 4)
ideal_state = ideal_state / ideal_state.norm()

# Calculate the fidelity
fidelity = state_fidelity(fitted_state, ideal_state, validate=False)

print(f'Fidelity of the GHZ state: {fidelity:.3f}')
