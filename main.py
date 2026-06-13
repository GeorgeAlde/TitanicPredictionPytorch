import torch
import torch.nn as nn
import torch.optim as optim
import data
from sklearn.model_selection import train_test_split

device = 'cuda' if torch.cuda.is_available() else 'cpu'

x = torch.tensor(data.get_data(), device=device, dtype=torch.float32)
y = torch.tensor(data.get_answers(),dtype=torch.float32,device=device).reshape(-1, 1)
x_train, x_test, y_train, y_test = train_test_split(
    x.cpu().numpy(),
    y.cpu().numpy(),
    test_size=0.2,
    random_state=42
)
x_train = torch.tensor(x_train, dtype=torch.float32, device=device)
x_test = torch.tensor(x_test, dtype=torch.float32, device=device)

y_train = torch.tensor(y_train, dtype=torch.float32, device=device)
y_test = torch.tensor(y_test, dtype=torch.float32, device=device)

